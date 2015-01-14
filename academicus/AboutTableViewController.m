//
//  AboutTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "AboutTableViewController.h"

@implementation AboutTableViewController


- (NSArray*)recipients
{
    if (_recipients == nil) {
        // Set the email recipiens
        _recipients = @[@"lheavens1@sheffield.ac.uk", @"bmcarr1@sheffield.ac.uk"];
    }
    return _recipients;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Override the height of the table view header
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 110);
    
    // Set the logo wrapper to a circle shape with an app tint background colour
    UIView *logoWrapper = (UIView *)[self.tableView.tableHeaderView viewWithTag:700];
    logoWrapper.backgroundColor = APP_TINT_COLOUR;
    logoWrapper.layer.masksToBounds = YES;
    logoWrapper.layer.cornerRadius = 45;
    
    // Add a gesture recogniser to respond to a tap
    UITapGestureRecognizer *tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoTapped)];
    tapGestureRecogniser.numberOfTapsRequired = 1;
    [logoWrapper addGestureRecognizer:tapGestureRecogniser];
}


- (void)logoTapped
{
    // Get the logo wrapper view
    UIView *logoWrapper = (UIView *)[self.tableView.tableHeaderView viewWithTag:700];
    
    // Create a keyframe animation to produce a bounce effect when tapped
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.2f;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8f, 0.8f, 1.0f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.autoreverses = NO;
    
    // Add the animation to the layer
    [logoWrapper.layer addAnimation:animation forKey: @"transform"];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self sendEmailWithSubject:@"Academicus Query" body:@"We're always happy to answer any questions or queries you may have about our app. Please write your query below."];
            break;
        case 1:
            [self sendEmailWithSubject:@"Academicus Bug Report" body:@"We're sorry you experienced a bug. Please explain the problem in as much detail as possible so we can try and fix it. Also let us know which phone and version of iOS you are using."];
            break;
        case 2:
            [self sendEmailWithSubject:@"Academicus Suggestion" body:@"We're always looking for feedback from our users. If you have a suggestion for our app, please let us know in the space below."];
            break;
        case 3:
            [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/idcom.sheffield.academicus"]];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)sendEmailWithSubject:(NSString *)subject body:(NSString *)body
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:subject];
    [mailComposer setMessageBody:body isHTML:NO];
    [mailComposer setToRecipients:self.recipients];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultFailed: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Unfortunately your email could not be sent. Please check your internet connection or try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
