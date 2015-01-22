//
//  PerformanceBySubjectCell.h
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"

@interface PerformanceBySubjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *performanceTitle;
@property (weak, nonatomic) IBOutlet UIView *performanceGraphView;
@property (weak, nonatomic) IBOutlet UIView *selectedModuleColourBlock;
@property (weak, nonatomic) IBOutlet UILabel *selectedModuleName;
@property (weak, nonatomic) IBOutlet UILabel *selectedModuleGrade;

@property (strong) NSArray* subjects;
@property (assign) float graphOriginX;
@property (assign) float graphOriginY;
@property (assign) float graphWidth;
@property (assign) float graphHeight;
@property (assign) float columnWidth;

- (void) configureCellWithSubjects: (NSArray*) subjects;

@end
