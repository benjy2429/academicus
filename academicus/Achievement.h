//
//  Achievement.h
//  academicus
//
//  Created by Luke on 13/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Portfolio;

@interface Achievement : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * dateAchieved;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) Portfolio *portfolio;

@end
