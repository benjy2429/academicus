//
//  HighestGradedAssessmentsCell.h
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentCriteria.h"

@interface HighestGradedAssessmentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gradeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstHighestLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondHighestLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdHighestLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstHighestGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondHighestGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdHighestGradeLabel;

- (void) configureCellWithHighestGrades: (NSArray*) gradeOrderedAssessments;

@end