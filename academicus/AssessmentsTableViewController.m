//
//  AssessmentsTableViewController.m
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AssessmentsTableViewController.h"

@implementation AssessmentsTableViewController
{
    // Local instance variable for the fetched results controller
    NSFetchedResultsController *_fetchedResultsController;
}


// Custom getter for the fetched results controller
- (NSFetchedResultsController*)fetchedResultsController
{
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Delete the cache to prevent inconsistencies in iOS7
    [NSFetchedResultsController deleteCacheWithName:@"Assessments"];
    
    // Retrieve the objects for this table view using CoreData
    [self performFetch];
    
    // Set the view title to the qualification name
    self.title = self.subject.name;
    
    // Initialise variable not in edit mode
    self.inSwipeDeleteMode = NO;
    
    // Add an edit button to the navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Override the height of the table view header
    self.headerView.frame = CGRectMake(0, 0, 0, 110);
    [self configureHeader];
}


- (void)performFetch
{
    // Fetch the data for the table view using CoreData
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        
        // Throw a custom error if the fetch fails
        COREDATA_ERROR(error);
        return;
    }
}


- (void)dealloc
{
    // Stop the fetched results controller from sending notifications if the view is deallocated
    _fetchedResultsController.delegate = nil;
}


- (void)configureHeader
{
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
    
    // Calculate the current grade from the marked assessments
    float currentGrade = 0.0f;
    NSArray *assessments = [self.fetchedResultsController.fetchedObjects mutableCopy];
    for (NSManagedObject *object in assessments) {
        AssessmentCriteria *assessment = (AssessmentCriteria *) object;
        if ([assessment.hasGrade boolValue]) {
            currentGrade += (([assessment.finalGrade floatValue] * [assessment.weighting floatValue]) / 100);
        }
    }
    currentLabel.text = [NSString stringWithFormat:@"%.0f%%", currentGrade];
    
    [self doMaskAnimation:targetWrapper percentageFill:[self.subject.targetGrade floatValue]];
    [self doMaskAnimation:currentWrapper percentageFill:currentGrade];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections
    // 1 for normal mode, 2 for edit mode to contain the add button
    return (self.isEditing && !self.inSwipeDeleteMode) ? 2 : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in each section
    // If the add button is visible, return 1 otherwise return the number of data items
    if (self.isEditing && !self.inSwipeDeleteMode && section == 1) {
        return 1;
    } else {
        return [self.subject.assessments count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
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
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d"];
    dueDateLabel.text = [formatter stringFromDate:currentAssessment.deadline];
    
    [formatter setDateFormat:@"MMM"];
    dueMonthLabel.text = [formatter stringFromDate:currentAssessment.deadline];
    
    nameLabel.text = currentAssessment.name;
    
    
    if (![currentAssessment.hasGrade boolValue]) {
        // Calculate the number of days between today and the assignment deadline
        NSDate *currentDate = [NSDate date];
        NSDate *deadlineDate = currentAssessment.deadline;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&currentDate interval:nil forDate:currentDate];
        [calendar rangeOfUnit:NSDayCalendarUnit startDate:&deadlineDate interval:nil forDate:deadlineDate];
        NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:currentDate toDate:deadlineDate options:0];
        
        if ([difference day] < 0) {
            countdownLabel.text = [NSString stringWithFormat:@"Deadline passed"];
        } else {
            countdownLabel.text = [NSString stringWithFormat:@"%ld days remaining", [difference day]];
        }
        
    } else {
        // Display the final grade
        UILabel *gradeLabel = (UILabel *) [cell viewWithTag:105];
        gradeLabel.text = [NSString stringWithFormat:@"%i%%", [currentAssessment.finalGrade intValue]];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (indexPath.section == 1) {
        return NO;
    } else {
        return YES;
    }
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if (!self.inSwipeDeleteMode && indexPath.section == 1) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
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
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set a flag variable and enable editing mode
    self.inSwipeDeleteMode = YES;
    [self setEditing:YES animated:YES];
}


// This method is run only when the user swipes to delete a row
- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable editing mode and reset the flag variable
    // Due to a bug in iOS 8.1, this method is called twice and crashes the app so check if in editing mode first
    if (self.editing) {
        [self setEditing:NO animated:YES];
        self.inSwipeDeleteMode = NO;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addAssessment"]) {
        UINavigationController *navController = segue.destinationViewController;
        AssessmentDetailTableViewController *controller = (AssessmentDetailTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
    
    } else if ([segue.identifier isEqualToString:@"editAssessment"]) {
        UINavigationController *navController = segue.destinationViewController;
        AssessmentDetailTableViewController *controller = (AssessmentDetailTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.managedObjectContext = self.managedObjectContext;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = [self.fetchedResultsController objectAtIndexPath:indexPath];

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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
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


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - AssessmentDetailTableViewControllerDelegate

- (void)AssessmentDetailTableViewController:(id)controller didFinishAddingAssessment:(AssessmentCriteria *)assessment
{
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
}


- (void)AssessmentDetailTableViewController:(id)controller didFinishEditingAssessment:(AssessmentCriteria *)assessment
{
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)AssessmentDetailTableViewControllerDidCancel:(id)controller
{
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - AssessmentGradeTableViewControllerDelegate

- (void)AssessmentGradeTableViewControllerDidCancel:(AssessmentGradeTableViewController*)controller
{
    // No action to take so dismiss the modal window
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)AssessmentGradeTableViewController:(AssessmentGradeTableViewController*)controller didFinishEditingAssessment:(AssessmentCriteria*)assessment
{
    // Save the item to the datastore
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        COREDATA_ERROR(error);
        return;
    }
    
    // Dismiss the edit item view
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 This method illustrates how to use a mask layer to hide/how part of the contents of a view, and how to
 create an animation that reveals/hides the contents of a layer.
 It creates a circular sweep animatinon that reveals an image in an arc, like the sweep of a radar display
 */
- (void) doMaskAnimation:(UIView*) sender percentageFill:(float)fillAmount;
{
    
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
