//
//  Year.m
//  academicus
//
//  Created by Ben on 28/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Year.h"

@implementation Year

@dynamic endDate;
@dynamic name;
@dynamic startDate;
@dynamic qualification;
@dynamic subjects;


// Get the total subject weights for the year
- (float) weightingAllocated {
    // Sum the weightings of all the existing subjects
    float weightingAllocated = 0.0f;
    for (Subject *subject in self.subjects) {
        weightingAllocated += [subject.yearWeighting floatValue];
    }
    
    return weightingAllocated;
}


@end

