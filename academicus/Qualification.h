//
//  Qualification.h
//  academicus
//
//  Created by Ben on 29/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Year.h"

@class Year;

@interface Qualification : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * institution;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSOrderedSet *years;
@end

@interface Qualification (CoreDataGeneratedAccessors)

- (void)insertObject:(Year *)value inYearsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromYearsAtIndex:(NSUInteger)idx;
- (void)insertYears:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeYearsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInYearsAtIndex:(NSUInteger)idx withObject:(Year *)value;
- (void)replaceYearsAtIndexes:(NSIndexSet *)indexes withYears:(NSArray *)values;
- (void)addYearsObject:(Year *)value;
- (void)removeYearsObject:(Year *)value;
- (void)addYears:(NSOrderedSet *)values;
- (void)removeYears:(NSOrderedSet *)values;

@end

