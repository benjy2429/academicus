//
//  MapViewController.m
//  academicus
//
//  Created by Ben on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    // Add a user tracking button to the navbar
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    [self.navigationItem setRightBarButtonItems:@[trackingButton] animated:YES];
    
    // Get the location services authorisation status
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    // Show the users location on the map if authorised
    self.mapView.showsUserLocation = (authorizationStatus == kCLAuthorizationStatusAuthorized || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
    
    // Set the navigation title to the name of the location
    self.title = self.location.name;
    
    // Add a pin at the location
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:self.location];
    [self.mapView addAnnotation:placemark];
    
    // Center the map on the pin
    [self centerMap];
}


- (void)centerMap {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    // Set the region to center on the pin
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = self.location.location.coordinate;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}


- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    // Get the location services authorisation status
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {

        // For iOS 8+, ask the user to authorise the use of location services
        self.locationManager = [[CLLocationManager alloc] init];
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager performSelector:@selector(requestWhenInUseAuthorization)];
        }
        
    } else if (authorizationStatus == kCLAuthorizationStatusDenied) {
        
        // If location services have been disabled, alert the user
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Location services have been disabled. Please enable them in the settings app to use this feature." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
}


@end

