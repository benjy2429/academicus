//
//  Portfolio.h
//  academicus
//
//  Created by Luke on 15/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Achievement, WorkExperience;

@interface Portfolio : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * hobbies;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSSet *achievements;
@property (nonatomic, retain) NSSet *workExperiences;
@end

@interface Portfolio (CoreDataGeneratedAccessors)

- (void)addAchievementsObject:(Achievement *)value;
- (void)removeAchievementsObject:(Achievement *)value;
- (void)addAchievements:(NSSet *)values;
- (void)removeAchievements:(NSSet *)values;

- (void)addWorkExperiencesObject:(WorkExperience *)value;
- (void)removeWorkExperiencesObject:(WorkExperience *)value;
- (void)addWorkExperiences:(NSSet *)values;
- (void)removeWorkExperiences:(NSSet *)values;

@end
