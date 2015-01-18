//
//  NumberOfYearsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "NumberOfYearsCell.h"

@implementation NumberOfYearsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithYears: (int) years
{
    if (years == 1) {
        self.yearsLabel.text = [NSString stringWithFormat: @"%i Year", years];
    } else {
        self.yearsLabel.text = [NSString stringWithFormat: @"%i Years", years];
    }
}

@end
