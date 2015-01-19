//
//  NumberOfAssessmentsCell.h
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberOfAssessmentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assessmentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *assessmentPicture;

- (void) configureCellWithAssessments: (int) numberOfAssessments;

@end
