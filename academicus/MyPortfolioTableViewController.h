//
//  MyPortfolioTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Portfolio.h"
#import "Achievement.h"
#import "MyPortfolioTableViewCell.h"

@interface MyPortfolioTableViewController : UITableViewController

@property (strong) Portfolio *portfolio;

@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
