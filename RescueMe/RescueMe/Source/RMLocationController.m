//
//  RMLocationController.m
//  RescueMe
//
//  Created by Kaushal Kantawala on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMLocationController.h"
#import "CoreLocation/CLLocationManager.h"
#import "Parse/Parse.h"
#import "Parse/PFGeopoint.h"

@interface RMLocationController()



@end

@implementation RMLocationController

+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (RMLocationController *) init
{
    _locationTimer = [[NSTimer alloc] init];
    return self;
}

-(void) startTimer:(NSInteger) timerLengthInMinutes
{
    [NSTimer scheduledTimerWithTimeInterval: timerLengthInMinutes * 60
                                     target: self
                                   selector:@selector(sendLocation:)
                                   userInfo: nil repeats:YES];
}

-(void) sendLocation:(NSTimer *)timer
{
    [self updateLocationInParse];
}

-(void) createLocationInParse
{
    [self getLocation];
    PFGeoPoint* gp = [PFGeoPoint geoPointWithLatitude:_lat longitude:_lon];
    PFObject* locationObject = [PFObject objectWithClassName:@"Location"];
    locationObject[@"deviceId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    locationObject[@"latitude"] = [NSNumber numberWithDouble:_lat];
    locationObject[@"longitude"] = [NSNumber numberWithDouble:_lon];
    locationObject[@"geopoint"] = gp;
    [locationObject saveInBackground];
    [self startTimer:5];
    
}

-(void) getLocation
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    _lat = (double)coordinate.latitude;
    _lon = (double)coordinate.longitude;

}

- (BOOL)locationServicesEnabled
{
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    BOOL result = (![CLLocationManager locationServicesEnabled] || (authorizationStatus == kCLAuthorizationStatusDenied)) ? NO : YES;
    return result;
}

-(void) updateLocationInParse
{
    [self getLocation];
    PFGeoPoint* gp = [PFGeoPoint geoPointWithLatitude:_lat longitude:_lon];
    NSString* devId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    [PFCloud callFunctionInBackground:@"updateLocation"
                       withParameters:@{@"deviceid": devId,
                                        @"latitude": [NSNumber numberWithDouble: _lat],
                                        @"longitude": [NSNumber numberWithDouble: _lon],
                                        @"geopoint" :gp
                                        }
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        // this is where you handle the results and change the UI.
                                        
                                    }
                                }];
}

-(void) resetTimer
{

}

@end
