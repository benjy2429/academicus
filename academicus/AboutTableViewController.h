//
//  AboutTableViewController.h
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *recipients;

@end
