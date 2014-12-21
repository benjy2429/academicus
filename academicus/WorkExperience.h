//
//  WorkExperience.h
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkExperience : NSObject

@property (strong) NSString *companyName;
@property (strong) NSString *companyAddress;
@property (strong) NSString *jobTitle;
@property (strong) NSDate *startDate;
@property (strong) NSDate *endDate;
@property (strong) NSString *refereeName;
@property (strong) NSString *refereeEmail;
@property (strong) NSString *details;

@end
