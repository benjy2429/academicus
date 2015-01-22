//
//  NumberOfSubjectsCell.h
//  academicus
//
//  Created by Luke on 22/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberOfSubjectsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

- (void) configureCellWithSubjects:(int) subjectCount;

@end
