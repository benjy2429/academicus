//
//  Qualification.h
//  academicus
//
//  Created by Ben on 28/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Qualification : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *years;
@end

@interface Qualification (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inYearsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromYearsAtIndex:(NSUInteger)idx;
- (void)insertYears:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeYearsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInYearsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceYearsAtIndexes:(NSIndexSet *)indexes withYears:(NSArray *)values;
- (void)addYearsObject:(NSManagedObject *)value;
- (void)removeYearsObject:(NSManagedObject *)value;
- (void)addYears:(NSOrderedSet *)values;
- (void)removeYears:(NSOrderedSet *)values;
@end
