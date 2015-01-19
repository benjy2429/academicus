//
//  HighestRatedAssessmentsCell.h
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentCriteria.h"

@interface HighestRatedAssessmentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ratingTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdRatingLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstRatingValue;
@property (weak, nonatomic) IBOutlet UILabel *secondRatingValue;
@property (weak, nonatomic) IBOutlet UILabel *thirdRatingValue;

@property (weak, nonatomic) IBOutlet UILabel *firstStar;
@property (weak, nonatomic) IBOutlet UILabel *secondStar;
@property (weak, nonatomic) IBOutlet UILabel *thirdStar;

- (void) configureCellWithHighestRatings: (NSArray*) ratingOrderedAssessments
;

@end
