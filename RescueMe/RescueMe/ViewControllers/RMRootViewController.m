//
//  RMRootViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMRootViewController.h"
#import "RMCommonConstants.h"
#import "Parse/Parse.h"

@interface RMRootViewController ()

@end

@implementation RMRootViewController

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
    
//    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:RM_DID_RECEIVE_PUSH_NOTIFICATION];
    
    PFObject *testObject = [PFObject objectWithClassName:@"RescueMeTestObject"];
    testObject[@"distressId"] = @"somedistressid";
    [testObject saveInBackground];
    
    _locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    _locationManager.delegate = self; // we set the delegate of locationManager to self.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    [_locationManager startUpdatingLocation];  //requesting location updates

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController * vc;
    
    BOOL didReceivePN = [[[NSUserDefaults standardUserDefaults] objectForKey:RM_DID_RECEIVE_PUSH_NOTIFICATION] boolValue];
    BOOL isUserLoggedIn = [[[NSUserDefaults standardUserDefaults] objectForKey:RM_IS_USER_LOGGED_IN] boolValue];
    
    
    if (didReceivePN) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"RMRescueMeNavigationController"];
                [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:RM_DID_RECEIVE_PUSH_NOTIFICATION];
    }
    else if (isUserLoggedIn) {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"RMDistressNavigationController"];
    }
    else {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"RMAccountNavigationController"];
    }
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

}

-(void)dismiss
{

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
