//
//  RMEmergencyContactsViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMEmergencyContactsViewController.h"

#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import "RMCommonConstants.h"

@interface RMEmergencyContactsViewController ()

@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation RMEmergencyContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contacts = [NSMutableArray array];
    self.emergencyContacts = [[NSUserDefaults standardUserDefaults] objectForKey:RM_EMERGENCY_CONTACTS];

    [self loadAddressBook];
    if (self.emergencyContacts.count < 3) {
        self.btnConfirmContacts.enabled = NO;
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadAddressBook
{
    CFErrorRef * error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABAddressBookRequestAccessWithCompletion
    (addressBook, ^(bool granted, CFErrorRef error)
     {
         if (granted)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
                 CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
                 
                 for (int i = 0; i < numberOfPeople; i++) {
                     ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
                     
                     NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                     NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));

                     if (firstName.length || lastName.length) {
                         NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                         
                         ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
                         
                         NSMutableArray *numbers = [NSMutableArray array];
                         for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                             NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                             [numbers addObject:phoneNumber];
                         }
                         
                         name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                         if (name.length && numbers.count) {
                             NSDictionary *contact = @{ @"name": name,
                                                        @"number" : numbers[0] };
                             [self.contacts addObject:contact];
                         }
                     }
                     
                     CFRelease(person);
                 }
                 
                 CFRelease(allPeople);
                 
                 [self.tableViewContactPicker reloadData];
             });
         }
     });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSDictionary *contact = self.contacts[indexPath.row];
    
    if ([self.emergencyContacts containsObject:contact]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    cell.textLabel.text = self.contacts[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.contacts[indexPath.row][@"number"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *contact = self.contacts[indexPath.row];

    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.emergencyContacts removeObject:contact];
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.btnConfirmContacts.enabled = NO;
    }
    else {
        if (self.emergencyContacts.count < 3) {
            [self.emergencyContacts addObject:contact];
            if (self.emergencyContacts.count == 3) {
                self.btnConfirmContacts.enabled = YES;
            }
                
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

- (void)btnConfirmContactsTapped:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:self.emergencyContacts forKey:RM_EMERGENCY_CONTACTS];
    for (NSDictionary *emergencyContact in self.emergencyContacts) {
        PFObject *emergencyContactObj = [PFObject objectWithClassName:@"EmergencyContacts"];
        emergencyContactObj[@"deviceId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];        
        emergencyContactObj[@"phoneNumber"] = emergencyContact[@"number"];
        [emergencyContactObj saveInBackground];
    }
}

@end
