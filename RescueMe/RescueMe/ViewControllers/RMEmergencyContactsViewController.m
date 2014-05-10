//
//  RMEmergencyContactsViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMEmergencyContactsViewController.h"

#import <AddressBook/AddressBook.h>

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
    [self loadAddressBook];
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
    
    cell.textLabel.text = self.contacts[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.contacts[indexPath.row][@"number"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
