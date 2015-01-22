//
//  NumberOfAssessmentsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "NumberOfAssessmentsCell.h"

@implementation NumberOfAssessmentsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithAssessments: (int) numberOfAssessments
{
    if (numberOfAssessments == 1) {
        self.assessmentsLabel.text = [NSString stringWithFormat: @"%i Assessment", numberOfAssessments];
    } else {
        self.assessmentsLabel.text = [NSString stringWithFormat: @"%i Assessments", numberOfAssessments];
    }
}

@end
