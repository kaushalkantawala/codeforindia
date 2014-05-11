//
//  RMDistressViewController.h
//  RescueMe
//
//  Created by Ronak Shah on 5/9/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CLLocationManagerDelegate.h"

@interface RMDistressViewController : UIViewController <CLLocationManagerDelegate>

@property(nonatomic) double lat;
@property(nonatomic) double lon;
@property (nonatomic, strong) IBOutlet UIButton *btnHelp;
//@property (nonatomic, strong) IBOutlet UIBarButtonItem *bbiSettings;
@property (strong, nonatomic) IBOutlet UIButton *btnStop;

- (IBAction)btnHelpTapped:(id)sender;
- (IBAction)btnStopTapped:(id)sender;

@end
