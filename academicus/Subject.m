//
//  Subject.m
//  academicus
//
//  Created by Ben on 29/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "Subject.h"

@implementation Subject

@dynamic name;
@dynamic targetGrade;
@dynamic teacherEmail;
@dynamic teacherName;
@dynamic yearWeighting;
@dynamic colour;
@dynamic assessments;
@dynamic year;
@dynamic displayOrder;


- (float) amountOfSubjectCompleted {
    float subjectCompleted = 0.0f;
    for (AssessmentCriteria *assessment in self.assessments) {
        if ([assessment.hasGrade boolValue]) {subjectCompleted += [assessment.weighting floatValue];}
    }
    return subjectCompleted;
}


- (float) weightingAllocated {
    float subjectAllocated = 0.0f;
    for (AssessmentCriteria *assessment in self.assessments) {
        subjectAllocated += [assessment.weighting floatValue];
    }
    return subjectAllocated;
}


- (float) calculateCurrentGrade {
    // Calculate the current grade from the marked assessments
    float currentGrade = 0.0f;
    for (AssessmentCriteria *assessment in self.assessments) {
        if ([assessment.hasGrade boolValue]) {
            currentGrade += (([assessment.finalGrade floatValue] * [assessment.weighting floatValue]) / 100);
        }
    }
    return currentGrade;
}


//Generate a subject string for the portfolio
- (NSString*) toStringForPorfolio {
    NSMutableArray *assessmentStrings = [[NSMutableArray alloc] init];
    
    //For each assesment that has a grade, generate an assessment string
    for (AssessmentCriteria *assessment in self.assessments) {
        if ([assessment.hasGrade boolValue]) {
            [assessmentStrings insertObject:[assessment toStringForPorfolio] atIndex:0];
        }
    }
    
    NSString* subjectString = [NSString stringWithFormat:@"            %@: %.0f%%", self.name, [self calculateCurrentGrade]];
    
    //If one or more assessment strings exist, add them to the subject string
    if (assessmentStrings.count > 0) {
        return [NSString stringWithFormat: @"%@\n%@", subjectString, [assessmentStrings componentsJoinedByString:@"\n"]];
    }
    
    return subjectString;
}

@end

