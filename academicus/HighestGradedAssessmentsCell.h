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

//Animation Properties
@property (strong) NSTimer* firstTimer;
@property (assign) int currentFirstGradeValue;
@property (assign) int finalFirstGradeValue;

@property (strong) NSTimer* secondTimer;
@property (assign) int currentSecondGradeValue;
@property (assign) int finalSecondGradeValue;

@property (strong) NSTimer* thirdTimer;
@property (assign) int currentThirdGradeValue;
@property (assign) int finalThirdGradeValue;

- (void) configureCellWithHighestGrades: (NSArray*) gradeOrderedAssessments;

@end
