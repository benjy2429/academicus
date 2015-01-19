//
//  AssessementsOnTargetCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "AssessmentsOnTargetCell.h"

@implementation AssessmentsOnTargetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithMetTarget:(int)assessmentsOnTarget gradedAssessments: (int) assessmentsGraded
{
    int percentageOnTarget = (assessmentsOnTarget/(float)assessmentsGraded) * 100;
    self.percentageOnTargetLabel.text = [NSString stringWithFormat: @"%i%%", percentageOnTarget];
}

@end
