//
//  HighestRatedAssessmentsCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "HighestRatedAssessmentsCell.h"

//Constant defining animation speed
const float HIGHEST_RATED_DURATION = 1.0f;

@implementation HighestRatedAssessmentsCell


- (void)awakeFromNib {}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//Configure the cell using an array of assessments sorted from highest rated to lowest rated
- (void) configureCellWithHighestRatings: (NSArray*) ratingOrderedAssessments {
    //Reset the cell
    [self.firstTimer invalidate];
    [self.secondTimer invalidate];
    [self.thirdTimer invalidate];
    
    self.firstStar.textColor = APP_TINT_COLOUR;
    self.secondStar.textColor = APP_TINT_COLOUR;
    self.thirdStar.textColor = APP_TINT_COLOUR;
    
    //If there is at least one assessment
    if ([ratingOrderedAssessments count] > 0) {
        //Use the assessment at position 0 to populate the first of the three highest assessment details
        AssessmentCriteria* assessment = (AssessmentCriteria*) ratingOrderedAssessments[0];
        self.firstRatingLabel.text = assessment.name;
        self.firstSubjectLabel.text = assessment.subject.name;
        
        //Animate the rating value from 0 to the rating value using an NSTimer
        self.currentFirstRatingValue = 0;
        self.finalFirstRatingValue = [assessment.rating intValue];
        [self updateFirstRating];
        self.firstTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_RATED_DURATION/self.finalFirstRatingValue) target:self selector:@selector(updateFirstRating) userInfo:nil repeats: YES];
    } else {
        //Otherwise do not show any details in this position
        self.firstRatingLabel.hidden = YES;
        self.firstRatingValue.text = @"-";
        self.firstSubjectLabel.hidden = YES;
    }
    
    //If there are at least two assessments
    if ([ratingOrderedAssessments count] > 1) {
        //We can take the second assessment and populate the second of the three highest assessment details
        AssessmentCriteria* assessment = (AssessmentCriteria*) ratingOrderedAssessments[1];
        self.secondRatingLabel.text = assessment.name;
        self.secondSubjectLabel.text = assessment.subject.name;
        
        //Animate the rating value from 0 to the rating value using an NSTimer
        self.currentSecondRatingValue = 0;
        self.finalSecondRatingValue = [assessment.rating intValue];
        [self updateSecondRating];
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_RATED_DURATION/self.finalSecondRatingValue) target:self selector:@selector(updateSecondRating) userInfo:nil repeats: YES];
    } else {
        //Otherwise do not show any details in this position
        self.secondRatingLabel.hidden = YES;
        self.secondRatingValue.text = @"-";
        self.secondSubjectLabel.hidden = YES;
    }
    
    //If there are at least 3 assessments
    if ([ratingOrderedAssessments count] > 2) {
        //Populate the thrid of the three highest assessment details with the third assessment in the array
        AssessmentCriteria* assessment = (AssessmentCriteria*) ratingOrderedAssessments[2];
        self.thirdRatingLabel.text = assessment.name;
        self.thirdSubjectLabel.text = assessment.subject.name;

        //Animate the rating value from 0 to the rating value using an NSTimer
        self.currentThirdRatingValue = 0;
        self.finalThirdRatingValue = [assessment.rating intValue];
        [self updateThirdRating];
        self.thirdTimer = [NSTimer scheduledTimerWithTimeInterval: (HIGHEST_RATED_DURATION/self.finalThirdRatingValue) target:self selector:@selector(updateThirdRating) userInfo:nil repeats: YES];
    } else {
        //Otherwise do not show any details in this position
        self.thirdRatingLabel.hidden = YES;
        self.thirdRatingValue.text = @"-";
        self.thirdSubjectLabel.hidden = YES;
    }
}


//Update the value of the first rating value
- (void) updateFirstRating {
    self.firstRatingValue.text = [NSString stringWithFormat: @"%i", self.currentFirstRatingValue];
    
    //If we have reached the final value, invalidate the timer and stop or increase the current value for the next iteration
    if (self.currentFirstRatingValue == (int) (self.finalFirstRatingValue)) {
        [self.firstTimer invalidate];
    } else {
        self.currentFirstRatingValue++;
    }
}


//Update the value of the second rating value
- (void) updateSecondRating {
    self.secondRatingValue.text = [NSString stringWithFormat: @"%i", self.currentSecondRatingValue];
    
    //If we have reached the final value, invalidate the timer and stop or increase the current value for the next iteration
    if (self.currentSecondRatingValue == (int) (self.finalSecondRatingValue)) {
        [self.secondTimer invalidate];
    } else {
        self.currentSecondRatingValue++;
    }
}


//Update the value of the third rating value
- (void) updateThirdRating {
    self.thirdRatingValue.text = [NSString stringWithFormat: @"%i", self.currentThirdRatingValue];
    
    //If we have reached the final value, invalidate the timer and stop or increase the current value for the next iteration
    if (self.currentThirdRatingValue == (int) (self.finalThirdRatingValue)) {
        [self.thirdTimer invalidate];
    } else {
        self.currentThirdRatingValue++;
    }
}


@end

