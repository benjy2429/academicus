//
//  Settings.h
//  academicus
//
//  Created by Ben on 18/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (assign) BOOL autoRemindersEnabled;
@property (assign) BOOL backupEnabled;
@property (assign) BOOL passcodeEnabled;
@property (assign) BOOL touchIdEnabled;
@property (assign) BOOL soundsEnabled;

@end
