//
//  Portfolio.h
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Portfolio : NSObject

@property (strong) NSString *name;
@property (strong) NSString *address;
@property (strong) NSString *phone;
@property (strong) NSString *email;
@property (strong) NSString *website;
@property (strong) UIImage *photo;
@property (strong) NSString *hobbies;
@property (strong) NSMutableArray *achievements;
@property (strong) NSMutableArray *workExperiences;

@end
