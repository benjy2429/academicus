//
//  Subject.h
//  academicus
//
//  Created by Ben on 29/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AssessmentCriteria, Year;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * targetGrade;
@property (nonatomic, retain) NSString * teacherEmail;
@property (nonatomic, retain) NSString * teacherName;
@property (nonatomic, retain) NSNumber * yearWeighting;
@property (nonatomic, retain) UIColor * colour;
@property (nonatomic, retain) NSOrderedSet *assessments;
@property (nonatomic, retain) Year *year;
@property (nonatomic, retain) NSNumber * displayOrder;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)insertObject:(AssessmentCriteria *)value inAssessmentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAssessmentsAtIndex:(NSUInteger)idx;
- (void)insertAssessments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAssessmentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAssessmentsAtIndex:(NSUInteger)idx withObject:(AssessmentCriteria *)value;
- (void)replaceAssessmentsAtIndexes:(NSIndexSet *)indexes withAssessments:(NSArray *)values;
- (void)addAssessmentsObject:(AssessmentCriteria *)value;
- (void)removeAssessmentsObject:(AssessmentCriteria *)value;
- (void)addAssessments:(NSOrderedSet *)values;
- (void)removeAssessments:(NSOrderedSet *)values;
@end
