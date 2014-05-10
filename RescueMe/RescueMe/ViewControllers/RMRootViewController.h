//
//  RMRootViewController.h
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CLLocationManager.h"

@interface RMRootViewController : UIViewController <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager* locationManager;

@end
