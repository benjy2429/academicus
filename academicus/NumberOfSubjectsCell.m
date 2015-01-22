//
//  NumberOfSubjectsCell.m
//  academicus
//
//  Created by Luke on 22/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "NumberOfSubjectsCell.h"

@implementation NumberOfSubjectsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithSubjects: (int) subjectCount {
    if (subjectCount == 1) {
        self.subjectLabel.text = [NSString stringWithFormat: @"%i Subject", subjectCount];
    } else {
        self.subjectLabel.text = [NSString stringWithFormat: @"%i Subjects", subjectCount];
    }
}

@end
