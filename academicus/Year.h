//
//  Year.h
//  academicus
//
//  Created by Ben on 28/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Qualification;

@interface Year : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) Qualification *qualification;
@property (nonatomic, retain) NSOrderedSet *subjects;
@end

@interface Year (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inSubjectsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSubjectsAtIndex:(NSUInteger)idx;
- (void)insertSubjects:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSubjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSubjectsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceSubjectsAtIndexes:(NSIndexSet *)indexes withSubjects:(NSArray *)values;
- (void)addSubjectsObject:(NSManagedObject *)value;
- (void)removeSubjectsObject:(NSManagedObject *)value;
- (void)addSubjects:(NSOrderedSet *)values;
- (void)removeSubjects:(NSOrderedSet *)values;
@end
