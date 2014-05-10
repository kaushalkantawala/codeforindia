//
//  RMEmergencyContactsViewController.h
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMEmergencyContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableViewContactPicker;
//@property (nonatomic, strong) IBOutlet UIButton *btnConfirmContacts;
//
//- (IBAction)btnConfirmContactsTapped:(id)sender;

@end
