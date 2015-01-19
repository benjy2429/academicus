//
//  HighestGradedAssessmentsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "HighestGradedAssessmentsCell.h"

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
    if ([gradeOrderedAssessments count] > 0) {
        AssessmentCriteria* assessent = (AssessmentCriteria*) gradeOrderedAssessments[0];
        self.firstHighestLabel.text = assessent.name;
        self.firstHighestGradeLabel.text = [NSString stringWithFormat:@"%i%%",[assessent.finalGrade intValue]];
    } else {
        self.firstHighestLabel.hidden = YES;
        self.firstHighestGradeLabel.hidden = YES;
    }
    
    if ([gradeOrderedAssessments count] > 1) {
        AssessmentCriteria* assessent = (AssessmentCriteria*) gradeOrderedAssessments[1];
        self.secondHighestLabel.text = assessent.name;
        self.secondHighestGradeLabel.text = [NSString stringWithFormat:@"%i%%",[assessent.finalGrade intValue]];
    } else {
        self.secondHighestLabel.hidden = YES;
        self.secondHighestGradeLabel.hidden = YES;
    }
    
    if ([gradeOrderedAssessments count] > 2) {
        AssessmentCriteria* assessent = (AssessmentCriteria*) gradeOrderedAssessments[2];
        self.thirdHighestLabel.text = assessent.name;
        self.thirdHighestGradeLabel.text = [NSString stringWithFormat:@"%i%%",[assessent.finalGrade intValue]];
    } else {
        self.thirdHighestLabel.hidden = YES;
        self.thirdHighestGradeLabel.hidden = YES;
    }
}

@end
