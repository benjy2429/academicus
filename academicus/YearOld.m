//
//  Year.m
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "YearOld.h"
#import "Subject.h"

@implementation YearOld

- (id) init {
    self = [super init];
    if (self) {
        _subjects = [[NSMutableArray alloc] init];
        Subject *s = [[Subject alloc] init]; //REMOVE SUBJECT IMPORT
        s.name = @"Test Subject";
        [_subjects addObject:s];
    }
    return self;
}

@end
