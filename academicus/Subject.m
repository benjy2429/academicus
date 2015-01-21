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


@end

