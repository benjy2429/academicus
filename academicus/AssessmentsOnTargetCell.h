//
//  AssessementsOnTargetCell.h
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssessmentsOnTargetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *onTargetLabel;

@property (weak, nonatomic) IBOutlet UILabel *percentageOnTargetLabel;

- (void) configureCellWithMetTarget:(int)assessmentsOnTarget gradedAssessments: (int) assessmentsGraded;

@end
