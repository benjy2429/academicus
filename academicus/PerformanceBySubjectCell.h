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

//Storyboard elements
@property (weak, nonatomic) IBOutlet UILabel *performanceTitle;
@property (weak, nonatomic) IBOutlet UIView *performanceGraphView;
@property (weak, nonatomic) IBOutlet UIView *selectedSubjectColourBlock;
@property (weak, nonatomic) IBOutlet UILabel *selectedSubjectName;
@property (weak, nonatomic) IBOutlet UILabel *selectedSubjectGrade;

@property (strong) NSArray* subjects;

//Animaiton properties
@property (assign) float graphOriginX;
@property (assign) float graphOriginY;
@property (assign) float graphWidth;
@property (assign) float graphHeight;
@property (assign) float columnWidth;

- (void) configureCellWithSubjects: (NSArray*) subjects;

@end
