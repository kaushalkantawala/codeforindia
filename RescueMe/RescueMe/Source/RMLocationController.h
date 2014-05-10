//
//  RMLocationController.h
//  RescueMe
//
//  Created by Kaushal Kantawala on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CLLocationManagerDelegate.h"

@interface RMLocationController : NSObject <CLLocationManagerDelegate>
{}

@property(nonatomic, strong) NSTimer* locationTimer;
@property(nonatomic) double lat;
@property(nonatomic) double lon;

+ (id)sharedInstance;
-(void) startTimer:(NSInteger) timerLengthInMinutes;
-(void) sendLocation:(NSTimer *)timer;
-(void) resetTimer;
-(void) createLocationInParse;
-(void) getLocation;
-(BOOL)locationServicesEnabled;
@end
