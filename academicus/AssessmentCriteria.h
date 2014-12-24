//
//  AssessmentCriteria.h
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssessmentCriteria : NSObject

@property (strong) NSString *name;
@property (assign) float weighting;
@property (strong) NSDate *deadline;
@property (strong) NSDate *reminder;
@property (assign) float finalGrade;
@property (assign) int rating;
@property (strong) NSString *positiveFeedback;
@property (strong) NSString *negativeFeedback;
@property (strong) NSString *notes;
@property (strong) UIImage *picture;

@property (assign) BOOL hasGrade;

@end
