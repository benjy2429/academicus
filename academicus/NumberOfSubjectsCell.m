//
//  NumberOfSubjectsCell.m
//  academicus
//
//  Created by Luke on 22/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "NumberOfSubjectsCell.h"

@implementation NumberOfSubjectsCell


- (void)awakeFromNib {}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//Configure the cell with the given number of subjects
- (void) configureCellWithSubjects: (int) subjectCount {
    //Display the label differently if there is only one subject
    if (subjectCount == 1) {
        self.subjectLabel.text = [NSString stringWithFormat: @"%i Subject", subjectCount];
    } else {
        self.subjectLabel.text = [NSString stringWithFormat: @"%i Subjects", subjectCount];
    }
}

@end
