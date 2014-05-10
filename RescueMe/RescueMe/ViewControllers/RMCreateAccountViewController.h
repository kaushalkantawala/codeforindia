//
//  RMCreateAccountViewController.h
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCreateAccountViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *txtFirstName;
@property (nonatomic, strong) IBOutlet UITextField *txtLastName;
@property (nonatomic, strong) IBOutlet UITextField *txtPassword;
@property (nonatomic, strong) IBOutlet UITextField *txtPhoneNumber;
@property (nonatomic, strong) IBOutlet UIButton *btnCreateAccount;

- (IBAction)btnCreateAccountTapped:(id)sender;

@end
