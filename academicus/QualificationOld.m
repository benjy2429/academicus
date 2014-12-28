//
//  Qualification.m
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "QualificationOld.h"
#import "Year.h"

@implementation QualificationOld

- (id) init {
    self = [super init];
    if (self) {
        _years = [[NSMutableArray alloc] init];
        Year *s = [[Year alloc] init]; //REMOVE YEAR IMPORT
        s.name = @"The Year 3000";
        s.startDate = [NSDate date];
        s.endDate = [NSDate date];
        [_years addObject:s];
    }
    return self;
}

@end
