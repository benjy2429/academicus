//
//  WorkExperience.h
//  academicus
//
//  Created by Luke on 13/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Portfolio;

@interface WorkExperience : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * companyAddress;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * refereeName;
@property (nonatomic, retain) NSNumber * refereeEmail;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) Portfolio *portfolio;

@end
