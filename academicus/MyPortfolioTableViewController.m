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
}


- (void)configureHeader
{
    [self.profileImage setImage:[UIImage imageWithData:self.portfolio.photo]];
    self.profileImage.layer.cornerRadius = 40;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.profileImage.layer.borderWidth = 1.0f;
    
    self.nameLabel.text = self.portfolio.name;
    
    // Set the header shadow
    self.tableView.tableHeaderView.layer.masksToBounds = NO;
    self.tableView.tableHeaderView.layer.shadowOffset = CGSizeMake(0, 3);
    self.tableView.tableHeaderView.layer.shadowRadius = 2;
    self.tableView.tableHeaderView.layer.shadowOpacity = 0.3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
            
            if (![self.portfolio.phone isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Telephone: %@", self.portfolio.phone]]; }
            if (![self.portfolio.email isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Email: %@", self.portfolio.email]]; }
            if (![self.portfolio.website isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Website: %@", self.portfolio.website]]; }
            if (![self.portfolio.website isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"Address: %@", self.portfolio.address.name]]; }
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n"];
            break;
            
        }
        case 1: {
            cell.titleLabel.text = @"Hobbies";
            cell.contentLabel.text = (![self.portfolio.hobbies isEqualToString:@""]) ? [NSString stringWithFormat:@"%@", self.portfolio.hobbies] : @"" ;
            break;
            
        }
        case 2: {
            cell.titleLabel.text = @"Achievements";
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            
            for (Achievement *achievement in self.portfolio.achievements) {
                [contentStrings addObject:[NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:achievement.dateAchieved], achievement.name]];
            }
            
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n"];
            break;
            
        }
        case 3: {
            cell.titleLabel.text = @"Work Experience";
            
            
            if (![self.portfolio.hobbies isEqualToString:@""]) { [contentStrings addObject:[NSString stringWithFormat:@"%@", self.portfolio.hobbies]]; }
            cell.contentLabel.text = [contentStrings componentsJoinedByString:@"\n"];
            break;
            
        }
    }

}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}


- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static MyPortfolioTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}


- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

@end
