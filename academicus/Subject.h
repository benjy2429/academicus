//
//  Subject.h
//  academicus
//
//  Created by Luke on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subject : NSObject

@property (strong) NSString *name;
@property (assign) float yearWeighting;
@property (assign) int targetGrade;
@property (strong) UIColor *colour;
@property (strong) UILocation *location;
@property (strong) NSString *teacherName;
@property (strong) NSString *teacherEmail;
@property (strong) NSMutableArray *assessments;

@end
