//
//  Qualification.m
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Qualification.h"
#import "Year.h"

@implementation Qualification

- (id) init {
    self = [super init];
    if (self) {
        _years = [[NSMutableArray alloc] init];
        Year *y = [[Year alloc] init]; //REMOVE YEAR IMPORT
        y.name = @"Test Year";
        [_years addObject:y];
    }
    return self;
}

@end
