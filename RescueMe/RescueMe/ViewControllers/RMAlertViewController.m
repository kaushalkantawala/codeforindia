//
//  RMAlertViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMAlertViewController.h"

#import "RMAlertMapViewController.h"

@interface RMAlertViewController ()

@end

@implementation RMAlertViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[RMAlertMapViewController class]]) {
        RMAlertMapViewController *vc = [segue destinationViewController];
        
        NSDictionary *location1 = @{@"lat": @(37.541832), @"long": @(-121.927941)};
        NSDictionary *location2 = @{@"lat": @(37.543108), @"long": @(-121.931213)};
        NSDictionary *location3 = @{@"lat": @(37.541798), @"long": @(-121.931159)};
        NSDictionary *location4 = @{@"lat": @(37.423041), @"long": @(-122.085630)};
        
        vc.points = @[location1, location2, location3, location4];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)btnDismissTapped:(id)sender
{
    
}

- (IBAction)btnCallPoliceTapped:(id)sender
{
    NSString *stringUrl = [NSString stringWithFormat:@"tel:%@", @"510-900-9211"];
    NSURL *url = [[NSURL alloc] initWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];

    [[UIApplication sharedApplication] openURL:url];
}

- (BOOL)canDeviceCall
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:+11111"]])
        return YES;
    else
        return NO;
}

@end
