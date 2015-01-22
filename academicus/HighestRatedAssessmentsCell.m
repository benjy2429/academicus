//
//  HighestRatedAssessmentsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "HighestRatedAssessmentsCell.h"

const float HIGHEST_RATED_DURATION = 1.0f;

@implementation HighestRatedAssessmentsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithHighestRatings: (NSArray*) ratingOrderedAssessments {
    if ([ratingOrderedAssessments count] > 0) {
        AssessmentCriteria* assessment = (AssessmentCriteria*) ratingOrderedAssessments[0];
        self.firstRatingLabel.text = assessment.name;
        self.firstStar.textColor = APP_TINT_COLOUR;
        
        self.currentFirstRatingValue = 0;
        self.finalFirstRatingValue = [assessment.rating intValue];
        [self updateFirstRating];
        self.firstTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_RATED_DURATION/self.finalFirstRatingValue) target:self selector:@selector(updateFirstRating) userInfo:nil repeats: YES];
    } else {
        self.firstRatingLabel.hidden = YES;
        self.firstRatingValue.hidden = YES;
        self.firstStar.hidden = YES;
    }
    
    if ([ratingOrderedAssessments count] > 1) {
        AssessmentCriteria* assessment = (AssessmentCriteria*) ratingOrderedAssessments[1];
        self.secondRatingLabel.text = assessment.name;
        self.secondStar.textColor = APP_TINT_COLOUR;
        
        self.currentSecondRatingValue = 0;
        self.finalSecondRatingValue = [assessment.rating intValue];
        [self updateSecondRating];
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_RATED_DURATION/self.finalSecondRatingValue) target:self selector:@selector(updateSecondRating) userInfo:nil repeats: YES];
    } else {
        self.secondRatingLabel.hidden = YES;
        self.secondRatingValue.hidden = YES;
        self.secondStar.hidden = YES;
    }
    
    if ([ratingOrderedAssessments count] > 2) {
        AssessmentCriteria* assessment = (AssessmentCriteria*) ratingOrderedAssessments[2];
        self.thirdRatingLabel.text = assessment.name;
        self.thirdStar.textColor = APP_TINT_COLOUR;
        
        self.currentThirdRatingValue = 0;
        self.finalThirdRatingValue = [assessment.rating intValue];
        [self updateThirdRating];
        self.thirdTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_RATED_DURATION/self.finalThirdRatingValue) target:self selector:@selector(updateThirdRating) userInfo:nil repeats: YES];
    } else {
        self.thirdRatingLabel.hidden = YES;
        self.thirdRatingValue.hidden = YES;
        self.thirdStar.hidden = YES;
    }
}


- (void) updateFirstRating {
    self.firstRatingValue.text = [NSString stringWithFormat: @"%i", self.currentFirstRatingValue];
    if (self.currentFirstRatingValue == (int) (self.finalFirstRatingValue)) {
        [self.firstTimer invalidate];
    } else {
        self.currentFirstRatingValue++;
    }
}

- (void) updateSecondRating {
    self.secondRatingValue.text = [NSString stringWithFormat: @"%i", self.currentSecondRatingValue];
    if (self.currentSecondRatingValue == (int) (self.finalSecondRatingValue)) {
        [self.secondTimer invalidate];
    } else {
        self.currentSecondRatingValue++;
    }
}

- (void) updateThirdRating {
    self.thirdRatingValue.text = [NSString stringWithFormat: @"%i", self.currentThirdRatingValue];
    if (self.currentThirdRatingValue == (int) (self.finalThirdRatingValue)) {
        [self.thirdTimer invalidate];
    } else {
        self.currentThirdRatingValue++;
    }
}

@end
