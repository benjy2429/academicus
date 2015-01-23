//
//  HighestGradedAssessmentsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "HighestGradedAssessmentsCell.h"

const float HIGHEST_GRADED_DURATION = 1.0f;

@implementation HighestGradedAssessmentsCell


- (void)awakeFromNib {}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) configureCellWithHighestGrades: (NSArray*) gradeOrderedAssessments {
    //Reset the cell
    [self.firstTimer invalidate];
    [self.secondTimer invalidate];
    [self.thirdTimer invalidate];
    
    //If there are is least 1 assessments
    if ([gradeOrderedAssessments count] > 0) {
        //Populate the first of the three highest assessment details with the first assessment in the array
        AssessmentCriteria* assessment = (AssessmentCriteria*) gradeOrderedAssessments[0];
        self.firstHighestLabel.text = assessment.name;
        self.firstSubjectLabel.text = assessment.subject.name;
 
        //Animate the grade value from 0 to the rating value using an NSTimer
        self.currentFirstGradeValue = 0;
        self.finalFirstGradeValue = [assessment.finalGrade intValue];
        [self updateFirstGrade];
        self.firstTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_GRADED_DURATION/self.finalFirstGradeValue) target:self selector:@selector(updateFirstGrade) userInfo:nil repeats: YES];
    } else {
        //Otherwise do not show any details in this position
        self.firstHighestLabel.hidden = YES;
        self.firstHighestGradeLabel.text = @"--%";
        self.firstSubjectLabel.hidden=YES;
    }
    
    //If there are at least 2 assessments
    if ([gradeOrderedAssessments count] > 1) {
        //Populate the second of the three highest assessment details with the second assessment in the array

        AssessmentCriteria* assessment = (AssessmentCriteria*) gradeOrderedAssessments[1];
        self.secondHighestLabel.text = assessment.name;
        self.secondSubjectLabel.text = assessment.subject.name;
        
        //Animate the grade value from 0 to the rating value using an NSTimer
        self.currentSecondGradeValue = 0;
        self.finalSecondGradeValue = [assessment.finalGrade intValue];
        [self updateSecondGrade];
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_GRADED_DURATION/self.finalSecondGradeValue) target:self selector:@selector(updateSecondGrade) userInfo:nil repeats: YES];
    } else {
        //Otherwise do not show any details in this position
        self.secondHighestLabel.hidden = YES;
        self.secondHighestGradeLabel.text = @"--%";
        self.secondSubjectLabel.hidden = YES;
    }
    
    //If there are at least 3 assessments
    if ([gradeOrderedAssessments count] > 2) {
        //Populate the thrid of the three highest assessment details with the third assessment in the array
        AssessmentCriteria* assessment = (AssessmentCriteria*) gradeOrderedAssessments[2];
        self.thirdHighestLabel.text = assessment.name;
        self.thirdSubjectLabel.text = assessment.subject.name;
        
        //Animate the grade value from 0 to the rating value using an NSTimer
        self.currentThirdGradeValue = 0;
        self.finalThirdGradeValue = [assessment.finalGrade intValue];
        [self updateThirdGrade];
        self.thirdTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_GRADED_DURATION/self.finalThirdGradeValue) target:self selector:@selector(updateThirdGrade) userInfo:nil repeats: YES];
    } else {
        //Otherwise do not show any details in this position
        self.thirdHighestLabel.hidden = YES;
        self.thirdHighestGradeLabel.text = @"--%";
        self.thirdSubjectLabel.hidden = YES;
    }
}


//Update the first grade value
- (void) updateFirstGrade {
    self.firstHighestGradeLabel.text = [NSString stringWithFormat: @"%i%%", self.currentFirstGradeValue];
    
    //If we have reached the final value, invalidate the timer and stop or increase the current value for the next iteration
    if (self.currentFirstGradeValue == (int) (self.finalFirstGradeValue)) {
        [self.firstTimer invalidate];
    } else {
        self.currentFirstGradeValue++;
    }
}


//Update the second grade value
- (void) updateSecondGrade {
    self.secondHighestGradeLabel.text = [NSString stringWithFormat: @"%i%%", self.currentSecondGradeValue];
    
    //If we have reached the final value, invalidate the timer and stop or increase the current value for the next iteration
    if (self.currentSecondGradeValue == (int) (self.finalSecondGradeValue)) {
        [self.secondTimer invalidate];
    } else {
        self.currentSecondGradeValue++;
    }
}


//Update the third grade value
- (void) updateThirdGrade {
    self.thirdHighestGradeLabel.text = [NSString stringWithFormat: @"%i%%", self.currentThirdGradeValue];
    
    //If we have reached the final value, invalidate the timer and stop or increase the current value for the next iteration
    if (self.currentThirdGradeValue == (int) (self.finalThirdGradeValue)) {
        [self.thirdTimer invalidate];
    } else {
        self.currentThirdGradeValue++;
    }
}


@end

