//
//  MyPortfolioTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Portfolio.h"
#import "Achievement.h"
#import "WorkExperience.h"
#import "MyPortfolioTableViewCell.h"
#import "Qualification.h"
#import "Year.h"
#import "Subject.h"
#import "AssessmentCriteria.h"

@interface MyPortfolioTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@property (strong) Portfolio *portfolio;
@property (strong) NSArray *qualifications;

@property (retain, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
