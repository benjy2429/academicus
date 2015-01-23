//
//  MyPortfolioTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MyPortfolioTableViewController.h"

static NSString * const CELL_IDENTIFIER = @"myPortfolioCell";

@implementation MyPortfolioTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Override the height of the table view header
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 135);
    
    [self configureHeader];
    [self performFetch];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Perform another fetch when the view appears incase the qualifications have changed
    [self performFetch];
    [self.tableView reloadData];
}


- (void)performFetch {
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


//This method configures the view area above the table view
- (void)configureHeader {
    //If the user has a personal photo we can display that
    if (self.portfolio.photo) {
        [self.profileImage setImage:[UIImage imageWithData:self.portfolio.photo]];
        self.profileImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.profileImage.layer.borderWidth = 1.0f;
    } else {
        //Otherwise use a stock photo
        UIImage *noPhotoImage = [[UIImage imageNamed:@"NoPhoto"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.profileImage setImage:noPhotoImage];
        self.profileImage.tintColor = APP_TINT_COLOUR;
    }
    //Round the image
    self.profileImage.layer.cornerRadius = 40;
    self.profileImage.layer.masksToBounds = YES;
    
    //Display the users name
    self.nameLabel.text = (self.portfolio.name && ![self.portfolio.name isEqualToString:@""]) ? self.portfolio.name : @"You haven't filled in your name!";
    
    // Set the header shadow
    self.tableView.tableHeaderView.layer.masksToBounds = NO;
    self.tableView.tableHeaderView.layer.shadowOffset = CGSizeMake(0, 3);
    self.tableView.tableHeaderView.layer.shadowRadius = 2;
    self.tableView.tableHeaderView.layer.shadowOpacity = 0.3;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}


- (MyPortfolioTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    MyPortfolioTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}


//Configure the current cell
- (void)configureBasicCell:(MyPortfolioTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //This array will contain the cell contents
    NSMutableArray *contentStrings = [[NSMutableArray alloc] init];
    
    //The content of the cell depends on the row
    switch (indexPath.row) {
        //The first row contains contact information
        case 0: {
            cell.titleLabel.text = @"Contact Details";
            
            if (self.portfolio.phone && ![self.portfolio.phone isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Telephone: %@", self.portfolio.phone]]; }
            if (self.portfolio.email && ![self.portfolio.email isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Email: %@", self.portfolio.email]]; }
            if (self.portfolio.website && ![self.portfolio.website isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Website: %@", self.portfolio.website]]; }
            if (self.portfolio.address) { [contentStrings addObject:[NSString stringWithFormat:@"Address: %@, %@", self.portfolio.address.name, [self.portfolio.address fullAddress]]]; }
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n\n"];
            break;
        }
        
        //The second row contains informaiton about the users academic progress
        case 1: {
            cell.titleLabel.text = @"Education";
            NSMutableArray* qualificationStrings = [[NSMutableArray alloc]init];

            //For each qualificaiton generate the qualificaiton string
            for (Qualification *qualification in self.qualifications) {
                [qualificationStrings addObject:[qualification toStringForPorfolio]];
            }
            
            //Add all the qualification strings to the cell
            cell.contentLabel.text = [qualificationStrings componentsJoinedByString:@"\n"];
            
            break;
        }
        
        //This row contains work information
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
            
        //This cell contains the users achievements
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
            
        //This row is populated by the users hobbies
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
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
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

//When the export portfolio button is clicked
- (IBAction)exportMyPortfolio {
    //Generate email body content
    NSString *body = [self generateEmailBody];
    
    //Create and show a mail composer view
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Academicus Portfolio Export"];
    [mailComposer setMessageBody:body isHTML:YES];
    [mailComposer.navigationBar setTintColor:[UIColor whiteColor]];
    //If we know their email we can add it to the recipients
    NSString *recipients = (self.portfolio.email && ![self.portfolio.email isEqualToString:@""]) ? self.portfolio.email : @"";
    [mailComposer setToRecipients:@[recipients]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}


//This method generates the content for the body of an email using the portfolio information
- (NSString *)generateEmailBody {
    NSString *body = (self.portfolio.name && ![self.portfolio.name isEqualToString:@""]) ? [NSString stringWithFormat:@"<h1>%@'s Portfolio</h1>", self.portfolio.name] : @"";
    
    //For each cell in the the table view add a corresponding cell to the email
    for (int i=0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        static MyPortfolioTableViewCell *emailCell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            emailCell = [self.tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
        });

        [self configureBasicCell:emailCell atIndexPath:indexPath];
        
        //Replace newlines with html breaks
        if (![emailCell.contentLabel.text isEqualToString:@""]) {
            NSString *contentWithBreaks = [emailCell.contentLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
            body = [NSString stringWithFormat:@"%@<hr><h2>%@</h2><p>%@</p>", body, emailCell.titleLabel.text, contentWithBreaks];
        }
    }
    return body;
}


//Called when the user is finished with the mail composer
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultFailed: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Unfortunately your email could not be sent. Please check your internet connection or try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default: break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

