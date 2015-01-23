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

//Storyboard elements
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

@property (weak, nonatomic) IBOutlet UILabel *firstSubjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondSubjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdSubjectLabel;


//Animation Properties
@property (strong) NSTimer* firstTimer;
@property (assign) int currentFirstRatingValue;
@property (assign) int finalFirstRatingValue;

@property (strong) NSTimer* secondTimer;
@property (assign) int currentSecondRatingValue;
@property (assign) int finalSecondRatingValue;

@property (strong) NSTimer* thirdTimer;
@property (assign) int currentThirdRatingValue;
@property (assign) int finalThirdRatingValue;

- (void) configureCellWithHighestRatings: (NSArray*) ratingOrderedAssessments;

@end

