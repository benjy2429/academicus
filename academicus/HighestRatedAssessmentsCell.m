//
//  HighestRatedAssessmentsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "HighestRatedAssessmentsCell.h"

@implementation HighestRatedAssessmentsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithHighestRatings: (NSArray*) ratingOrderedAssessments
{
    if ([ratingOrderedAssessments count] > 0) {
        AssessmentCriteria* assessent = (AssessmentCriteria*) ratingOrderedAssessments[0];
        self.firstRatingLabel.text = assessent.name;
        self.firstRatingValue.text = [NSString stringWithFormat:@"%i",[assessent.rating intValue]];
        self.firstStar.textColor = APP_TINT_COLOUR;
    } else {
        self.firstRatingLabel.hidden = YES;
        self.firstRatingValue.hidden = YES;
        self.firstStar.hidden = YES;
    }
    
    if ([ratingOrderedAssessments count] > 1) {
        AssessmentCriteria* assessent = (AssessmentCriteria*) ratingOrderedAssessments[1];
        self.secondRatingLabel.text = assessent.name;
        self.secondRatingValue.text = [NSString stringWithFormat:@"%i",[assessent.rating intValue]];
        self.secondStar.textColor = APP_TINT_COLOUR;
    } else {
        self.secondRatingLabel.hidden = YES;
        self.secondRatingValue.hidden = YES;
        self.secondStar.hidden = YES;
    }
    
    if ([ratingOrderedAssessments count] > 2) {
        AssessmentCriteria* assessent = (AssessmentCriteria*) ratingOrderedAssessments[2];
        self.thirdRatingLabel.text = assessent.name;
        self.thirdRatingValue.text = [NSString stringWithFormat:@"%i",[assessent.rating intValue]];
        self.thirdStar.textColor = APP_TINT_COLOUR;
    } else {
        self.thirdRatingLabel.hidden = YES;
        self.thirdRatingValue.hidden = YES;
        self.thirdStar.hidden = YES;
    }
}

@end
