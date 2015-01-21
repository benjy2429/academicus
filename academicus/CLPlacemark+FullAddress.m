//
//  CLPlacemark+FullAddress.m
//  academicus
//
//  Created by Ben on 21/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "CLPlacemark+FullAddress.h"

@implementation CLPlacemark (FullAddress)
// This category adds an additional method to a CLPlacemark object

// Display the full address of the placemark from the address dictionary
- (NSString *)fullAddress {
    NSMutableArray *addressComponents = [[NSMutableArray alloc] init];
    
    if (self.subThoroughfare) { [addressComponents addObject:self.subThoroughfare]; }
    if (self.thoroughfare) { [addressComponents addObject:self.thoroughfare]; }
    if (self.locality) { [addressComponents addObject:self.locality]; }
    if (self.postalCode) { [addressComponents addObject:self.postalCode]; }
    if (self.country) { [addressComponents addObject:self.country]; }
    
    return [addressComponents componentsJoinedByString:@", "];
}

@end
