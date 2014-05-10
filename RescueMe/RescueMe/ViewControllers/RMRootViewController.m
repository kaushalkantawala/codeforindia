//
//  RMRootViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMRootViewController.h"

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

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RMAccountNavigationController"];
    [self presentViewController:vc animated:YES completion:nil];
    
//    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RMRescueMeNavigationController"];
//    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RMDistressViewController"];
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

@end
