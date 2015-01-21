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


//Generate a string for the portfolio
- (NSString*) toStringForPorfolio {
    NSMutableArray *subjectStrings = [[NSMutableArray alloc] init];
    float totalYearGrade = 0.0f;
    
    //For each subject generate a subject string and calculate information for the year string
    for (Subject *subject in self.subjects) {
        totalYearGrade += (([subject calculateCurrentGrade] * [subject.yearWeighting floatValue]) / 100);
        //Generate the subject string
        [subjectStrings insertObject: [subject toStringForPorfolio] atIndex:0];
    }
    
    //Generate the year string
    NSString* yearString = [NSString stringWithFormat:@"      %@: %.0f%%", self.name, totalYearGrade];
    if (subjectStrings.count > 0) {
        return [NSString stringWithFormat: @"%@\n%@", yearString, [subjectStrings componentsJoinedByString:@"\n"]];
    }
    
    return yearString;
}
@end

