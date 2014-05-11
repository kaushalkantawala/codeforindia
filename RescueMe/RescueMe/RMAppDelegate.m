//
//  RMAppDelegate.m
//  RescueMe
//
//  Created by Ronak Shah on 5/9/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMAppDelegate.h"
#import <Parse/Parse.h>
#import "RMCommonConstants.h"

@implementation RMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];

    sleep(2);
    
    [Parse setApplicationId:@"ffpXx4E4hBuTvY05bCs6Pc6F0myJKHM19tJ82b0s"
                  clientKey:@"zlxOwHZNoyaZKMHlM4Ikxyaus14c15kXY6zFQHJh"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    NSString* deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"deviceId"];
    
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    if(apsInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:RM_DID_RECEIVE_PUSH_NOTIFICATION];
        [[NSUserDefaults standardUserDefaults] setObject:[apsInfo objectForKey:@"alert"] forKey:@"victimName"];
        [[NSUserDefaults standardUserDefaults] setObject:[apsInfo objectForKey:@"title"] forKey:@"distressId"];
        [self.window.rootViewController.view layoutSubviews];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    NSArray* channelsList = [NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"],nil];
    [currentInstallation setChannels:channelsList];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
//    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController* vc = [mainstoryboard instantiateViewControllerWithIdentifier:@"RMRescueMeNavigationController"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if (apsInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:RM_DID_RECEIVE_PUSH_NOTIFICATION];
        [[NSUserDefaults standardUserDefaults] setObject:[apsInfo objectForKey:@"alert"] forKey:@"victimName"];
        [[NSUserDefaults standardUserDefaults] setObject:[apsInfo objectForKey:@"title"] forKey:@"distressId"];
        [self.window.rootViewController.view layoutSubviews];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
//    [self.window.rootViewController performSelector:@selector(dismiss:) withObject:nil];
//    [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
//        [self.window.rootViewController presentViewController:vc animated:NO completion:NULL];
//    }];
}

@end

