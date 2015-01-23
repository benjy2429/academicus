//
//  NumberOfYearsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "NumberOfYearsCell.h"

@implementation NumberOfYearsCell


- (void)awakeFromNib {}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//Configure the cell with a given number of years
- (void) configureCellWithYears: (int) years {
    //Display the label differently if there is only one year
    if (years == 1) {
        self.yearsLabel.text = [NSString stringWithFormat: @"%i Year", years];
    } else {
        self.yearsLabel.text = [NSString stringWithFormat: @"%i Years", years];
    }
    
    //Display the current year on top of the calender image
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    self.yearLabel.text = [formatter stringFromDate:[NSDate date]];
    [self.yearLabel setTransform:CGAffineTransformMakeRotation(-(12/(float)180)*M_PI)];
}


@end

