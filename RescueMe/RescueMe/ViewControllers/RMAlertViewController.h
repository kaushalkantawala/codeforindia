//
//  RMAlertViewController.h
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMAlertViewController : UIViewController

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *distressId;
@property (nonatomic, strong) IBOutlet UILabel *lblDistressedInfo;
@property (nonatomic, strong) IBOutlet UIButton *btnDismiss;
@property (nonatomic, strong) IBOutlet UIButton *btnCallPolice;

- (IBAction)btnDismissTapped:(id)sender;
- (IBAction)btnCallPoliceTapped:(id)sender;

@end
