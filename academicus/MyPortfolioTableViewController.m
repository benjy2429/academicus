//
//  MyPortfolioTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MyPortfolioTableViewController.h"

static NSString * const cellIdentifier = @"myPortfolioCell";

@implementation MyPortfolioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Override the height of the table view header
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 135);
    
    [self configureHeader];
    [self performFetch];
}


- (void)performFetch
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Get the objects from the managed object context
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Qualification" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the sorting preference
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    // Fetch the data for the table view using CoreData
    NSError *error;
    self.qualifications = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Make sure there were no errors fetching the data
    if (error != nil) {
        COREDATA_ERROR(error);
        return;
    }
}


- (void)configureHeader
{
    if (self.portfolio.photo) {
        [self.profileImage setImage:[UIImage imageWithData:self.portfolio.photo]];
        self.profileImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.profileImage.layer.borderWidth = 1.0f;
    } else {
        UIImage *noPhotoImage = [[UIImage imageNamed:@"NoPhoto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.profileImage setImage:noPhotoImage];
        self.profileImage.tintColor = APP_TINT_COLOUR;
    }
    self.profileImage.layer.cornerRadius = 40;
    self.profileImage.layer.masksToBounds = YES;
    
    self.nameLabel.text = (self.portfolio.name && ![self.portfolio.name isEqualToString:@""]) ? self.portfolio.name : @"You haven't filled in your name!";
    
    // Set the header shadow
    self.tableView.tableHeaderView.layer.masksToBounds = NO;
    self.tableView.tableHeaderView.layer.shadowOffset = CGSizeMake(0, 3);
    self.tableView.tableHeaderView.layer.shadowRadius = 2;
    self.tableView.tableHeaderView.layer.shadowOpacity = 0.3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}


- (MyPortfolioTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    MyPortfolioTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureBasicCell:(MyPortfolioTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *contentStrings = [[NSMutableArray alloc] init];
    
    switch (indexPath.row) {
        case 0: {
            cell.titleLabel.text = @"Contact Details";
            
            if (self.portfolio.phone && ![self.portfolio.phone isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Telephone: %@", self.portfolio.phone]]; }
            if (self.portfolio.email && ![self.portfolio.email isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Email: %@", self.portfolio.email]]; }
            if (self.portfolio.website && ![self.portfolio.website isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Website: %@", self.portfolio.website]]; }
            if (self.portfolio.address) { [contentStrings addObject:[NSString stringWithFormat:@"Address: %@", self.portfolio.address.name]]; }
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n"];
            break;
            
        }
        case 1: {
            cell.titleLabel.text = @"Education";
            
            for (Qualification *qualification in self.qualifications) {
                NSDate *startDate = nil;
                NSDate *endDate = nil;
                
                for (Year *year in qualification.years) {
                    NSMutableArray *subjectStrings = [[NSMutableArray alloc] init];
                    float totalYearGrade = 0.0f;
                    
                    // Calculate the date ranges of the qualification
                    if (!startDate || !endDate) {
                        startDate = year.startDate;
                        endDate = year.endDate;
                    } else {
                        if ([startDate timeIntervalSince1970] > [year.startDate timeIntervalSince1970]) { startDate = year.startDate; }
                        if ([endDate timeIntervalSince1970] < [year.endDate timeIntervalSince1970]) { endDate = year.endDate; }
                    }
                    
                    for (Subject *subject in year.subjects) {
                        float totalSubjectGrade = 0.0f;
                        
                        for (AssessmentCriteria *assessment in subject.assessments) {
                            if ([assessment.hasGrade boolValue]) {
                                float weightedGrade = (([assessment.finalGrade floatValue] * [assessment.weighting floatValue]) / 100);
                                totalSubjectGrade += (([assessment.finalGrade floatValue] * [assessment.weighting floatValue]) / 100);
                                [subjectStrings addObject:[NSString stringWithFormat:@"        %@: %.0f%%", assessment.name, weightedGrade]];
                            }
                        }
                        totalYearGrade += ((totalSubjectGrade * [subject.yearWeighting floatValue]) / 100);
                    }
                    [contentStrings addObject:[NSString stringWithFormat:@"    %@: %.0f%%", year.name, totalYearGrade]];
                    if (subjectStrings.count > 0) { [contentStrings addObject:[NSString stringWithFormat:@"%@", [subjectStrings componentsJoinedByString:@"\n"]]]; }
                }
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY"];
                
                [contentStrings insertObject:[NSString stringWithFormat:@"%@ (%@ - %@)\n%@", qualification.name, [formatter stringFromDate:startDate], [formatter stringFromDate:endDate], qualification.institution] atIndex:0];
                
            }
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n"];
            
            break;
            
        }
        case 2: {
            cell.titleLabel.text = @"Work Experience";
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM YYYY"];
            
            for (WorkExperience *work in self.portfolio.workExperiences) {
                [contentStrings addObject:[NSString stringWithFormat:@"%@ - %@:\n%@ at %@", [formatter stringFromDate:work.startDate], [formatter stringFromDate:work.endDate], work.jobTitle, work.companyName]];
            }
            
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n\n"];
            break;
        }
        case 3: {
            cell.titleLabel.text = @"Achievements";
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            
            for (Achievement *achievement in self.portfolio.achievements) {
                [contentStrings addObject:[NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:achievement.dateAchieved], achievement.name]];
            }
            
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n"];
            break;
            
        }
        case 4: {
            cell.titleLabel.text = @"Hobbies";
            cell.contentLabel.text = (self.portfolio.hobbies && ![self.portfolio.hobbies isEqualToString:@""]) ? [NSString stringWithFormat:@"%@", self.portfolio.hobbies] : @"" ;
            break;
            
        }
    }

}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static MyPortfolioTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    
    if ([sizingCell.contentLabel.text isEqualToString:@""]) {
        return 0.0f;
    }

    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}


#pragma mark - MFMailComposeViewControllerDelegate

- (IBAction)exportMyPortfolio
{
    NSString *body = [self generateEmailBody];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Academicus Portfolio Export"];
    [mailComposer setMessageBody:body isHTML:YES];
    NSString *recipients = (self.portfolio.email && ![self.portfolio.email isEqualToString:@""]) ? self.portfolio.email : @"";
    [mailComposer setToRecipients:@[recipients]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}


- (NSString *)generateEmailBody
{
    NSString *body = (self.portfolio.name && ![self.portfolio.name isEqualToString:@""]) ? [NSString stringWithFormat:@"<h1>%@'s Portfolio</h1>", self.portfolio.name] : @"";
    
    for (int i=0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        static MyPortfolioTableViewCell *emailCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            emailCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        });

        [self configureBasicCell:emailCell atIndexPath:indexPath];
        
        if (![emailCell.contentLabel.text isEqualToString:@""]) {
            NSString *contentWithBreaks = [emailCell.contentLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
            body = [NSString stringWithFormat:@"%@<hr><h2>%@</h2><p>%@</p>", body, emailCell.titleLabel.text, contentWithBreaks];
        }
    }
    return body;
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
