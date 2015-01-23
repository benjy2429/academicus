//
//  AssessmentsTableViewController.m
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AssessmentsTableViewController.h"

@implementation AssessmentsTableViewController {
    // Local instance variable for the fetched results controller
    NSFetchedResultsController *_fetchedResultsController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Delete the cache to prevent inconsistencies in iOS7
    [NSFetchedResultsController deleteCacheWithName:@"Assessments"];
    
    // Set the view title to the qualification name
    self.title = self.subject.name;
    
    // Retrieve the objects for this table view using CoreData
    [self performFetch];
    
    // Initialise variable not in edit mode
    self.inSwipeDeleteMode = NO;
    
    // Add an edit button to the navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.weightingAllocated = [self.subject weightingAllocated];
    self.subjectCompleted = [self.subject amountOfSubjectCompleted];
    self.currentGrade = [self.subject calculateCurrentGrade];
    
    // Override the height of the table view header
    self.headerView.frame = CGRectMake(0, 0, 0, 125);
    
    [self configureExpandableInfo];
    
    [self configureHeader];
    
    // Set the header shadow
    self.headerView.layer.masksToBounds = NO;
    self.headerView.layer.shadowOffset = CGSizeMake(0, 3);
    self.headerView.layer.shadowRadius = 2;
    self.headerView.layer.shadowOpacity = 0.3;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Reload the table view to ensure data is up to date
    // Do this everytime the view appears incase the content is changed on another tab
    [self.tableView reloadData];
}


#pragma mark - Core Data

// Custom getter for the fetched results controller
- (NSFetchedResultsController*)fetchedResultsController {
    // Initialise the fetched results controller if nil
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        // Get the objects from the managed object context
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"AssessmentCriteria" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Set the sorting preference
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Set the predicate
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subject == %@", self.subject];
        [fetchRequest setPredicate:predicate];
        
        // Create the fetched results controller
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Assessments"];
        
        // Assign this class as the delegate
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}


- (void)performFetch {
    // Fetch the data for the table view using CoreData
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        // Throw a custom error if the fetch fails
        COREDATA_ERROR(error);
        return;
    }
}


- (void)dealloc {
    // Stop the fetched results controller from sending notifications if the view is deallocated
    _fetchedResultsController.delegate = nil;
}


#pragma mark - Table Header Area

// Initialise and configure the expandable subject view
- (void) configureExpandableInfo {
    [self.expandBtn addTarget:self action: @selector(toggleSubjectInformation) forControlEvents:UIControlEventTouchUpInside];
    self.isSubjectExpanded = false;
    self.expandSize = 0;
    float sizePerField = 37.5;
    
    //Populate fields in this section based on information about the subject
    self.subjectProgressLabel.text = [NSString stringWithFormat: @"Subject Completed: %2.f%%", self.subjectCompleted];
    self.expandSize += sizePerField;

    if (![self.subject.teacherName isEqualToString:@""]) {
        self.teacherNameLabel.text = [NSString stringWithFormat: @"Teacher Name: %@", self.subject.teacherName];
        self.expandSize += sizePerField;
    } else {
        [self.teacherNameLabel performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }
    
    if (![self.subject.teacherEmail isEqualToString:@""]) {
        [self.teacherEmailAddressButton setTitle:self.subject.teacherEmail forState: UIControlStateNormal];
        self.expandSize += sizePerField;
    } else {
        [self.teacherEmailAddressLabel performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        [self.teacherEmailAddressButton performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        [self.teacherEmailScrollView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    }
      
    if (self.weightingAllocated == 100) {
        CGRect frame = self.warningLabel.frame;
        frame.size.height = 0;
        [self.warningLabel setFrame:frame];
        self.exclamationLabel.hidden = YES;
    } else {
        CGRect frame = self.warningLabel.frame;
        frame.size.height = 18;
        [self.warningLabel setFrame:frame];
        self.exclamationLabel.hidden = NO;
        self.expandSize += 30;
    }
}


// Toggle the visibility of the subject information view with animations
- (void)toggleSubjectInformation {
    [self.tableView beginUpdates];
    
    int adjustmentSize = self.expandSize + 5;
    if (self.isSubjectExpanded) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.headerView.frame;
            [self.headerView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-adjustmentSize)];
            frame = self.expandBtn.frame;
            [self.expandBtn setFrame:CGRectMake(frame.origin.x, frame.origin.y-adjustmentSize, frame.size.width, frame.size.height)];
            frame = self.exclamationLabel.frame;
            [self.exclamationLabel setFrame:CGRectMake(frame.origin.x, frame.origin.y-adjustmentSize, frame.size.width, frame.size.height)];
        } completion: ^(BOOL finished) {
            [self.expandBtn setTitle:@"Show subject details" forState:UIControlStateNormal];            
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.headerView.frame;
            [self.headerView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+adjustmentSize)];
            frame = self.expandBtn.frame;
            [self.expandBtn setFrame:CGRectMake(frame.origin.x, frame.origin.y+adjustmentSize, frame.size.width, frame.size.height)];
            frame = self.exclamationLabel.frame;
            [self.exclamationLabel setFrame:CGRectMake(frame.origin.x, frame.origin.y+adjustmentSize, frame.size.width, frame.size.height)];
        } completion: ^(BOOL finished) {
            CGRect frame = self.subjectProgressLabel.superview.frame;
            [self.subjectProgressLabel.superview setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.expandSize)];
            [self.expandBtn setTitle:@"Hide subject details" forState:UIControlStateNormal];

        }];

    }
    self.isSubjectExpanded = !self.isSubjectExpanded;
    
    [self.tableView endUpdates];
}


// Initialise and configure the header information
- (void)configureHeader {
    // Get the views and labels from the header
    UILabel *targetLabel = (UILabel *)[self.headerView viewWithTag:201];
    UIView *targetWrapper = (UIView *)[self.headerView viewWithTag:202];
    UILabel *currentLabel = (UILabel *)[self.headerView viewWithTag:203];
    UIView *currentWrapper = (UIView *)[self.headerView viewWithTag:204];
    
    // Set the views to display as circles with coloured borders
    targetWrapper.layer.cornerRadius = 30;
    currentWrapper.layer.cornerRadius = 30;
    targetWrapper.layer.borderWidth = 3;
    currentWrapper.layer.borderWidth = 3;
    targetWrapper.clipsToBounds = YES;
    currentWrapper.clipsToBounds = YES;
    targetWrapper.layer.borderColor = [self.subject.colour CGColor];
    currentWrapper.layer.borderColor = [self.subject.colour CGColor];
    
    // Set the target grade
    targetLabel.text = [NSString stringWithFormat:@"%@%%", self.subject.targetGrade];
    
    currentLabel.text = [NSString stringWithFormat:@"%.0f%%", self.currentGrade];
    
    [self doMaskAnimation:targetWrapper percentageFill:[self.subject.targetGrade floatValue]];
    [self doMaskAnimation:currentWrapper percentageFill:self.currentGrade];
    
    UILabel *currentGradeTitleLabel = (UILabel *)[self.headerView viewWithTag:50];
    currentGradeTitleLabel.text = (self.subjectCompleted == 100) ? @"Final Grade" : @"Current Grade";
}


#pragma mark - Email

//When the teacher email is clicked, compose a new email with the teachers email as a recipient
- (IBAction)emailButtonTapped:(id)sender {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSString *recipients = (self.subject.teacherEmail && ![self.subject.teacherEmail isEqualToString:@""]) ? self.subject.teacherEmail : @"";
    [mailComposer setToRecipients:@[recipients]];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}


//When the user has finished with the email
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections
    // 1 for normal mode, 2 for edit mode to contain the add button
    return (self.isEditing && !self.inSwipeDeleteMode) ? 2 : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in each section
    // If the add button is visible, return 1 otherwise return the number of data items
    return (self.isEditing && !self.inSwipeDeleteMode && section == 1) ? 1 : [self.subject.assessments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check whether the current cell is the add new item cell
    BOOL isAddCell = (self.isEditing && !self.inSwipeDeleteMode && indexPath.section == 1);
    
    // Assign the correct identifier for this cell
    NSString *myIdentifier;
    if (isAddCell) {
        myIdentifier = @"addCell";
    } else {
        AssessmentCriteria *currentAssessment = [self.fetchedResultsController objectAtIndexPath:indexPath];
        myIdentifier = ([currentAssessment.hasGrade boolValue]) ? @"gradedAssessmentCell" : @"assessmentCell";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    }
    
    // Set the content for each type of cell
    if (isAddCell) {
        cell.textLabel.text = @"Add new assessment";
    } else {
        [self configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath {
    // Get the object for this cell and set the labels
    AssessmentCriteria *currentAssessment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Get the labels from the cell
    UILabel *dueDateLabel = (UILabel *) [cell viewWithTag:100];
    UILabel *dueMonthLabel = (UILabel *) [cell viewWithTag:101];
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:102];
    UILabel *countdownLabel = (UILabel *) [cell viewWithTag:103];
    
    // Colour red if the deadline has passed
    if (![currentAssessment.hasGrade boolValue] && [[NSDate date] compare:currentAssessment.deadline] == NSOrderedDescending) {
        dueDateLabel.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.0f alpha:1.0f];
        dueMonthLabel.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.0f alpha:1.0f];
    } else {
        dueDateLabel.textColor = [UIColor blackColor];
        dueMonthLabel.textColor = [UIColor blackColor];
    }
    
    nameLabel.text = currentAssessment.name;

    // Calculate and display the days remaining
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d"];
    dueDateLabel.text = [formatter stringFromDate:currentAssessment.deadline];
    
    [formatter setDateFormat:@"MMM"];
    dueMonthLabel.text = [formatter stringFromDate:currentAssessment.deadline];
    
    if (![currentAssessment.hasGrade boolValue]) {
        // Calculate the number of days between today and the assignment deadline
        countdownLabel.text = [currentAssessment getFriendlyDaysRemaining];
    } else {
        // Display the final grade
        UILabel *gradeLabel = (UILabel *) [cell viewWithTag:105];
        gradeLabel.text = [NSString stringWithFormat:@"%i%%", [currentAssessment.finalGrade intValue]];
        countdownLabel.text = @"Completed";
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing && !self.inSwipeDeleteMode) {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            // If the user clicks the add button, perform a segue to the add page
            [self performSegueWithIdentifier:@"addAssessment" sender:self];
            
        } else if (indexPath.section == 0) {
            // If the user clicks an item cell in edit mode, perform a segue to the edit page
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self performSegueWithIdentifier:@"editAssessment" sender:cell];
        }
        
    } else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"addGrade" sender:cell];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


# pragma mark - Reordering Cells

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Set to nil to perform reordering manually
    self.fetchedResultsController.delegate = nil;
    
    // Copy the results into a mutable array
    NSMutableArray *orderedItems = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    
    // Move the reordered item in the array
    AssessmentCriteria *assessment = [self.fetchedResultsController objectAtIndexPath:fromIndexPath];
    [orderedItems removeObject:assessment];
    [orderedItems insertObject:assessment atIndex:toIndexPath.row];
    
    // Iterate through the objects and update the display order to match the array order
    NSInteger i = [orderedItems count] - 1;
    for (NSManagedObject *item in orderedItems) {
        [item setValue:[NSNumber numberWithInteger:i] forKey:@"displayOrder"];
        i--;
    }
    
    // Save the objects back
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Reassign the fetched results controller delegate
    self.fetchedResultsController.delegate = self;
    
    // Perform another fetch to ensure the cache is up to date
    [self performFetch];

}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Prevent the add item cell from being reordered
    return (indexPath.section != 1);
}


//Prevent re-ordering below the add new. Will move as far as possible rather than returning to its starting position
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}


# pragma mark - Editing Cells

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AssessmentCriteria *assessment = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:assessment];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            COREDATA_ERROR(error);
            return;
        }
    }
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the add or delete icons to the correct cells
    return (!self.inSwipeDeleteMode && indexPath.section == 1) ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (self.isSubjectExpanded) {[self toggleSubjectInformation];}
    
    [super setEditing:editing animated:animated];
    
    // If the user swiped, the add item button does not need to be added
    if (self.inSwipeDeleteMode) {
        return;
    }
    
    // Add or remove the add item section if entering or exiting edit mode
    if (editing) {
        [self.tableView beginUpdates];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}


// This method is run only when the user swipes to delete a row
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set a flag variable and enable editing mode
    self.inSwipeDeleteMode = YES;
    [self setEditing:YES animated:YES];
}


// This method is run only when the user swipes to delete a row
- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Disable editing mode and reset the flag variable
    // Due to a bug in iOS 8.1, this method is called twice and crashes the app so check if in editing mode first
    if (self.editing) {
        [self setEditing:NO animated:YES];
        self.inSwipeDeleteMode = NO;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addAssessment"]) {
        UINavigationController *navController = segue.destinationViewController;
        AssessmentDetailTableViewController *controller = (AssessmentDetailTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        controller.weightingAllocated = self.weightingAllocated;
    
    } else if ([segue.identifier isEqualToString:@"editAssessment"]) {
        UINavigationController *navController = segue.destinationViewController;
        AssessmentDetailTableViewController *controller = (AssessmentDetailTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = [self.fetchedResultsController objectAtIndexPath:indexPath];
        controller.weightingAllocated = self.weightingAllocated - [controller.itemToEdit.weighting floatValue];

    } else if ([segue.identifier isEqualToString:@"addGrade"]) {
        UINavigationController *navController = segue.destinationViewController;
        AssessmentGradeTableViewController *controller = (AssessmentGradeTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    // Modify table rows depending on the action performed
    // (Called automatically by the NSFetchedResultsController)
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - AssessmentDetailTableViewControllerDelegate

- (void)AssessmentDetailTableViewController:(id)controller didFinishAddingAssessment:(AssessmentCriteria *)assessment {
    assessment.subject = self.subject;
    assessment.displayOrder = [NSNumber numberWithInteger:[[self.fetchedResultsController fetchedObjects] count]];
    
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the add item view
    [self dismissViewControllerAnimated:YES completion:nil];
    [self viewDidLoad];
}


- (void)AssessmentDetailTableViewController:(id)controller didFinishEditingAssessment:(AssessmentCriteria *)assessment {
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];
    [self viewDidLoad];
}


- (void)AssessmentDetailTableViewControllerDidCancel:(id)controller {
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - AssessmentGradeTableViewControllerDelegate

- (void)AssessmentGradeTableViewControllerDidCancel:(AssessmentGradeTableViewController*)controller {
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)AssessmentGradeTableViewController:(AssessmentGradeTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment {
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }

    // Need to reload the view to update the header information
    [self viewDidLoad];
    
    //If a grade has been entered
    if (assessment.finalGrade != nil) {
        // Display a feedback message based on the final grade
        NSString* feedbackTitle;
        NSString* feedbackMessage;
        if (self.subjectCompleted == 100) {
            if (self.currentGrade < [self.subject.targetGrade floatValue]) {
                feedbackTitle = @"Awww man!";
                feedbackMessage = @"It looks like your final grade for this subject is a little short of your target. Keep positive and use this as a learning experience. Focus on meeting your other targets with greater determination!";
            } else {
                feedbackTitle = @"Woo hoo!";
                feedbackMessage = @"Way to go, you've finished the subject and met your goal! Treat yourself, you deserve it.";
            }
        } else {
            if ([assessment.finalGrade floatValue] < [self.subject.targetGrade floatValue]) {
                feedbackTitle = @"Oh no!";
                feedbackMessage = @"It looks like you fell short of your target this time. Keep trying though, there is still time to increase your mark!";
            } else {
                feedbackTitle = @"Nice work!";
                feedbackMessage = @"You met your target for this assessment. You've just proved you can attain the marks you want if you have the right mindset. Keep up the good work!";
            }
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: feedbackTitle message: feedbackMessage delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void) doMaskAnimation:(UIView*) sender percentageFill:(float)fillAmount {
    
    //Create a shape layer that we will use as a mask for the waretoLogoLarge image view
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    //CGFloat maskHeight = sender.layer.bounds.size.height;
    //CGFloat maskWidth = sender.layer.bounds.size.width;
    CGFloat maskHeight = 60;
    CGFloat maskWidth = 60;
    
    //Make the radius of our arc large enough to reach into the corners of the image view.
    CGFloat outerRadius = 25;
    CGFloat innerRadius = 20;
    
    //Make the line thick enough to completely fill the circle we're drawing
    maskLayer.lineWidth = 10; 

    //Create the center point
    CGPoint centerPoint = CGPointMake( maskWidth/2, maskHeight/2);

    CGMutablePathRef arcPath = CGPathCreateMutable();
    
    //Move to the starting point of the arc so there is no initial line connecting to the arc
    CGPathMoveToPoint(arcPath, nil, centerPoint.x, centerPoint.y-outerRadius);
    //Create animaiton arc
    float endAngle = (fillAmount != 0) ? (((2*M_PI)/100)*fillAmount)-M_PI_2 : 0.0001-M_PI_2;
    CGPathAddArc(arcPath, nil, centerPoint.x, centerPoint.y, outerRadius, -M_PI_2, endAngle, NO);
    
    CGPathMoveToPoint(arcPath, nil, centerPoint.x, centerPoint.y-innerRadius);
    CGPathAddArc(arcPath, nil, centerPoint.x, centerPoint.y, innerRadius, -M_PI_2, 2*M_PI, NO);
    
    // Set the path to the mask layer.
    maskLayer.path = arcPath;
    
    //Maket the fill and stroke transparent (black)
    maskLayer.fillColor = [[UIColor blackColor] CGColor];
    maskLayer.strokeColor = [[UIColor blackColor] CGColor];
    
    //Start with an empty mask path (draw 0% of the arc, number between 0-1)
    maskLayer.strokeEnd = 0.0;
    
    // Release the path since it's not covered by ARC.
    CGPathRelease(arcPath);
    
    // Set the mask of the view.
    sender.layer.mask = maskLayer;
    
    //Create an animation that increases the stroke length to 1, then reverses it back to zero.
    CABasicAnimation *swipe = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    swipe.duration = 2;
    swipe.delegate = self;
    swipe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    swipe.fillMode = kCAFillModeForwards;
    swipe.removedOnCompletion = NO;
    swipe.autoreverses = NO;
    
    swipe.toValue = [NSNumber numberWithFloat: 1.0];
    
    [maskLayer addAnimation: swipe forKey: @"strokeEnd"];
}


@end

