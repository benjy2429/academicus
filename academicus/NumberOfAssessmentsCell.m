//
//  NumberOfAssessmentsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "NumberOfAssessmentsCell.h"

@implementation NumberOfAssessmentsCell


- (void)awakeFromNib {}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//Configure the cell with a number of assessments
- (void) configureCellWithAssessments: (int) numberOfAssessments {
    //Display the label differently if there is only one assessment
    if (numberOfAssessments == 1) {
        self.assessmentsLabel.text = [NSString stringWithFormat: @"%i Assessment", numberOfAssessments];
    } else {
        self.assessmentsLabel.text = [NSString stringWithFormat: @"%i Assessments", numberOfAssessments];
    }
}


@end

