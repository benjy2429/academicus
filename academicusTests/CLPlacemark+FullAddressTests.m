//
//  CLPlacemark+FullAddressTests.m
//  academicus
//
//  Created by Ben on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CLPlacemark+FullAddress.h"
#import <CoreLocation/CoreLocation.h>

@interface CLPlacemark_FullAddressTests : XCTestCase
@property (strong) CLGeocoder *geocoder;
@property (strong) CLPlacemark *placemark;
@end

@implementation CLPlacemark_FullAddressTests

- (void)setUp {
    [super setUp];
    self.geocoder = [[CLGeocoder alloc] init];
}


- (void)tearDown {
    [super tearDown];
    self.placemark = nil;
    self.geocoder = nil;
}


- (void)forwardGeocode:(NSString *)query {
    [self.geocoder cancelGeocode];
    [self.geocoder geocodeAddressString:query completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            NSLog(@"%ld", placemarks.count);
            self.placemark = [placemarks objectAtIndex:0];
        }
    }];
}


- (void)testFullAddress {
    [self forwardGeocode:@"apple inc"];
    NSLog(@"%@",[self.placemark fullAddress]);
    XCTAssertTrue([[self.placemark fullAddress] isEqualToString:@"Cupertino, 95014, United States"]);
}


- (void)testFullAddressEmpty {
    XCTAssertTrue([[self.placemark fullAddress] isEqualToString:@""]);
}


@end

