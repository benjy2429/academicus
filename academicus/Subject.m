//
//  Subject.m
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Subject.h"

@implementation Subject

- (id) init {
    self = [super init];
    if (self) {
        _assessments = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
