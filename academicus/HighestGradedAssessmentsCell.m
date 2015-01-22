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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithHighestGrades: (NSArray*) gradeOrderedAssessments
{
    [self.firstTimer invalidate];
    [self.secondTimer invalidate];
    [self.thirdTimer invalidate];
    
    if ([gradeOrderedAssessments count] > 0) {
        AssessmentCriteria* assessment = (AssessmentCriteria*) gradeOrderedAssessments[0];
        self.firstHighestLabel.text = assessment.name;
        self.firstSubjectLabel.text = assessment.subject.name;
        self.currentFirstGradeValue = 0;
        self.finalFirstGradeValue = [assessment.finalGrade intValue];
        [self updateFirstGrade];
        self.firstTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_GRADED_DURATION/self.finalFirstGradeValue) target:self selector:@selector(updateFirstGrade) userInfo:nil repeats: YES];
    } else {
        self.firstHighestLabel.hidden = YES;
        self.firstHighestGradeLabel.text = @"--%";
        self.firstSubjectLabel.hidden=YES;
    }
    
    if ([gradeOrderedAssessments count] > 1) {
        AssessmentCriteria* assessment = (AssessmentCriteria*) gradeOrderedAssessments[1];
        self.secondHighestLabel.text = assessment.name;
        self.secondSubjectLabel.text = assessment.subject.name;
        self.currentSecondGradeValue = 0;
        self.finalSecondGradeValue = [assessment.finalGrade intValue];
        [self updateSecondGrade];
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_GRADED_DURATION/self.finalSecondGradeValue) target:self selector:@selector(updateSecondGrade) userInfo:nil repeats: YES];
    } else {
        self.secondHighestLabel.hidden = YES;
        self.secondHighestGradeLabel.text = @"--%";
        self.secondSubjectLabel.hidden = YES;
    }
    
    if ([gradeOrderedAssessments count] > 2) {
        AssessmentCriteria* assessment = (AssessmentCriteria*) gradeOrderedAssessments[2];
        self.thirdHighestLabel.text = assessment.name;
        self.thirdSubjectLabel.text = assessment.subject.name;
        self.currentThirdGradeValue = 0;
        self.finalThirdGradeValue = [assessment.finalGrade intValue];
        [self updateThirdGrade];
        self.thirdTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_GRADED_DURATION/self.finalThirdGradeValue) target:self selector:@selector(updateThirdGrade) userInfo:nil repeats: YES];
    } else {
        self.thirdHighestLabel.hidden = YES;
        self.thirdHighestGradeLabel.text = @"--%";
        self.thirdSubjectLabel.hidden = YES;
    }
}

- (void) updateFirstGrade {
    self.firstHighestGradeLabel.text = [NSString stringWithFormat: @"%i%%", self.currentFirstGradeValue];
    if (self.currentFirstGradeValue == (int) (self.finalFirstGradeValue)) {
        [self.firstTimer invalidate];
    } else {
        self.currentFirstGradeValue++;
    }
}

- (void) updateSecondGrade {
    self.secondHighestGradeLabel.text = [NSString stringWithFormat: @"%i%%", self.currentSecondGradeValue];
    if (self.currentSecondGradeValue == (int) (self.finalSecondGradeValue)) {
        [self.secondTimer invalidate];
    } else {
        self.currentSecondGradeValue++;
    }
}

- (void) updateThirdGrade {
    self.thirdHighestGradeLabel.text = [NSString stringWithFormat: @"%i%%", self.currentThirdGradeValue];
    if (self.currentThirdGradeValue == (int) (self.finalThirdGradeValue)) {
        [self.thirdTimer invalidate];
    } else {
        self.currentThirdGradeValue++;
    }
}

@end
