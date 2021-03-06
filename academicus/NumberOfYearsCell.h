//
//  NumberOfYearsCell.h
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberOfYearsCell : UITableViewCell

//Storyboard elements
@property (weak, nonatomic) IBOutlet UIImageView *yearsPicture;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel; //The year that appears on top of the calender
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;

- (void) configureCellWithYears: (int) years;

@end
