//
//  AssessmentCriteria.h
//  academicus
//
//  Created by Ben on 29/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Subject.h"

@class Subject;

@interface AssessmentCriteria : NSManagedObject

@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSNumber * finalGrade;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * negativeFeedback;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * positiveFeedback;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSDate * reminder;
@property (nonatomic, retain) NSNumber * weighting;
@property (nonatomic, retain) NSNumber * hasGrade;
@property (nonatomic, retain) Subject *subject;
@property (nonatomic, retain) NSNumber * displayOrder;

- (void)createReminder;
- (void)removeReminder;
- (void)createDeadlineReminder;
- (void)removeDeadlineReminder;
- (NSString*) getFriendlyDaysRemaining;
- (NSString*) toStringForPorfolio;

@end

