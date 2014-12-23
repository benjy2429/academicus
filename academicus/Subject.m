//
//  Subject.m
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Subject.h"
#import "AssessmentCriteria.h"

@implementation Subject

- (id) init {
    self = [super init];
    if (self) {
        _assessments = [[NSMutableArray alloc] init];
        AssessmentCriteria *a = [[AssessmentCriteria alloc] init]; //REMOVE ASSESSMENT IMPORT
        a.name = @"Test Assessment Criteria";
        a.weighting = 12.5f;
        a.deadline = [NSDate date];
        a.reminder = [NSDate date];
        [_assessments addObject:a];
    }
    return self;
}

@end
