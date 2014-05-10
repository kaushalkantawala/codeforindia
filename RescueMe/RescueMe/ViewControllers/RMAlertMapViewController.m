//
//  RMAlertMapViewController.m
//  RescueMe
//
//  Created by Ronak Shah on 5/10/14.
//  Copyright (c) 2014 DJ911. All rights reserved.
//

#import "RMAlertMapViewController.h"

@interface RMAlertMapViewController ()

@end

@implementation RMAlertMapViewController

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

    [self routeForPoints:self.points];    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)routeForPoints:(NSArray *)points
{
    MKMapRect zoomRect = MKMapRectNull;
    for (int i = 0; i < points.count; i++)
    {
        CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([self.points[i][@"lat"] doubleValue], [self.points[i][@"long"] doubleValue]);
        MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:location1 addressDictionary:nil];

        if ((i + 1) < points.count) {
            CLLocationCoordinate2D location2 = CLLocationCoordinate2DMake([self.points[i + 1][@"lat"] doubleValue], [self.points[i + 1][@"long"] doubleValue]);
            
            MKPlacemark *placemark2 = [[MKPlacemark alloc] initWithCoordinate:location2 addressDictionary:nil];

            [self routeBetweenLocationOne:placemark1 andLocationTwo:placemark2];
        }
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(placemark1.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }

    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)routeBetweenLocationOne:(MKPlacemark *)placemark1 andLocationTwo:(MKPlacemark *)placemark2
{
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:placemark1];
    MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:placemark2];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = mapItem1;
    request.destination = mapItem2;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error : %@", error);
        }
        else {
            [self showDirections:response]; //response is provided by the CompletionHandler
        }
    }];
}

- (void)showDirections:(MKDirectionsResponse *)response
{
    // For single route
//    for (MKRoute *route in response.routes) {
    MKRoute *route = response.routes[0];
    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
//    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
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

- (IBAction)btnRouteTapped:(id)sender
{
    [self openDirectionTo:((MKPlacemark *)self.points[self.points.count - 1]).coordinate];
}

- (void)openDirectionTo:(CLLocationCoordinate2D)destinationCoordinate
{
    NSString* urlStr;
    NSString *source = @"Current+Location";
    NSString *destination = [NSString stringWithFormat:@"%f,%f", destinationCoordinate.latitude, destinationCoordinate.longitude];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6)
//    {
//        CLLocation *currentLocation = nil;//[[OMCoreLocationService sharedOMCoreLocationService] currentLocation];
//        //iOS 6+, Should use map.apple.com. Current Location doesn't work in iOS 6 . Must provide the coordinate.
//        if ((currentLocation.coordinate.latitude != kCLLocationCoordinate2DInvalid.latitude) && (currentLocation.coordinate.longitude != kCLLocationCoordinate2DInvalid.longitude))
//        {
//            //Valid location.
//            source = [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
//            
//            urlStr = [NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%@&daddr=%@", source, destination];
//        }
//        else
//        {
//            //Invalid location. Location Service disabled.
//            urlStr = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%@", destination];
//        }
//    }
//    else
//    {
        // Prior to iOS 6. Use maps.google.com
        urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@", source, destination];
//    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

@end
