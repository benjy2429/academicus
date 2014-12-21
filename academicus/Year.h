//
//  Year.h
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Year : NSObject

@property (strong) NSString *name;
@property (strong) NSDate *startDate;
@property (strong) NSDate *endDate;
@property (strong) NSMutableArray *subjects;

@end
