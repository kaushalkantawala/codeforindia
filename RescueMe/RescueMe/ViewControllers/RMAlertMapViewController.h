//
//  RMAlertMapViewController.h
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RMAlertMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *btnRoute;

- (IBAction)btnRouteTapped:(id)sender;

@end
