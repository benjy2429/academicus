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
        Year *s = [[Year alloc] init]; //REMOVE YEAR IMPORT
        s.name = @"Test Year";
        [_years addObject:s];
    }
    return self;
}

@end
