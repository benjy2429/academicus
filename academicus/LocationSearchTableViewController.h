//
//  LocationSearchTableViewController.h
//  academicus
//
//  Created by Ben on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CLPlacemark+FullAddress.h"
#import "MapViewController.h"

@class LocationSearchTableViewController;

// Delegate protocol
@protocol LocationSearchTableViewControllerDelegate <NSObject>
- (void)locationSearchTableViewControllerDidCancel:(LocationSearchTableViewController*)controller;
- (void)locationSearchTableViewController:(LocationSearchTableViewController*)controller didSelectLocation:(CLPlacemark *)location;
- (void)locationSearchTableViewControllerDidRemoveLocation:(LocationSearchTableViewController*)controller;
@end

@interface LocationSearchTableViewController : UITableViewController <UISearchBarDelegate, UIScrollViewDelegate>

@property (weak) id <LocationSearchTableViewControllerDelegate> delegate;

@property (strong) CLGeocoder *geocoder;
@property (strong) CLPlacemark *currentLocation;
@property (strong) NSArray *locations;

@end
