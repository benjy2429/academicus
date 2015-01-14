//
//  Portfolio.h
//  academicus
//
//  Created by Luke on 13/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Achievement, WorkExperience;

@interface Portfolio : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) Achievement *achievements;
@property (nonatomic, retain) WorkExperience *workExperiences;

@end
