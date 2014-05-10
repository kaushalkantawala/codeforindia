//
//  RMCreateAccountViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMCreateAccountViewController.h"
#import "Parse/Parse.h"

@interface RMCreateAccountViewController ()

@end

@implementation RMCreateAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txtFirstName.delegate = self;
    _txtLastName.delegate = self;
    _txtPassword.delegate = self;
    _txtPhoneNumber.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtPassword)
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)btnCreateAccountTapped:(id)sender
{
    NSString* deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [[NSUserDefaults standardUserDefaults] setObject:_txtFirstName.text forKey:@"FirstName"];
    [[NSUserDefaults standardUserDefaults] setObject:_txtLastName.text forKey:@"LastName"];
    [[NSUserDefaults standardUserDefaults] setObject:_txtPassword.text forKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] setObject:_txtPhoneNumber.text forKey:@"Phone"];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"deviceId"];
    
    PFObject* userObject = [PFObject objectWithClassName:@"UserObject"];
    userObject[@"UserId"] = deviceId;
    userObject[@"FirstName"] = _txtFirstName.text;
    userObject[@"LastName"] = _txtLastName.text;
    userObject[@"Password"] = _txtPassword.text;
    userObject[@"Phone"] = _txtPhoneNumber.text;
    userObject[@"DeviceId"] = deviceId;
    [userObject saveInBackground];
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

@end
