//
//  RMDistressViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/9/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMDistressViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CLLocationManager.h>

@interface RMDistressViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation RMDistressViewController

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
    self.btnStop.hidden = YES;
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

- (void)btnHelpTapped:(id)sender
{
    self.btnStop.hidden = NO;
    self.btnHelp.hidden = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 50.0;
    [self.locationManager startUpdatingLocation];
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    self.lat = (double)coordinate.latitude;
    self.lon = (double)coordinate.longitude;
}

- (IBAction)btnStopTapped:(id)sender
{
    self.btnStop.hidden = YES;
    self.btnHelp.hidden = NO;
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

- (void)sendDistressCall
{
    PFObject *testObject = [PFObject objectWithClassName:@"distress"];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (unsigned long)[[NSDate date] timeIntervalSince1970]];
    NSString *distressId = [NSString stringWithFormat:@"%@%@", deviceId, timestamp];
    
    testObject[@"distressId"] = distressId;
    testObject[@"deviceId"] = deviceId;
    testObject[@"latitude"] = [NSNumber numberWithDouble:self.lat];
    testObject[@"longitude"] = [NSNumber numberWithDouble:self.lon];
    testObject[@"miles"] = @(5);
    testObject[@"ack"] = @[@""];
    [testObject saveInBackground];
    
    [PFCloud callFunctionInBackground:@"push"
                       withParameters:@{ @"distressId": distressId }
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        // this is where you handle the results and change the UI.
                                    }
                                }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    self.lat = location.coordinate.latitude;
    self.lon = location.coordinate.longitude;
    [self sendDistressCall];
}

@end
