//
//  SubjectDetailTableViewController.m
//  academicus
//
//  Created by Luke on 21/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "SubjectDetailTableViewController.h"

@implementation SubjectDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Assign tags to the fields
    self.nameField.tag = 0;
    self.weightingField.tag = 1;
    self.targetField.tag = 2;
    
    // If an item was passed through, change the window title and populate the fields with existing data
    if (self.itemToEdit != nil) {
        self.title = @"Edit Subject";
        
        self.nameField.text = self.itemToEdit.name;
        self.weightingField.text = [NSString stringWithFormat: @"%.2f", [self.itemToEdit.yearWeighting floatValue]];
        self.weighting = [self.itemToEdit.yearWeighting floatValue];
        self.targetField.text = [NSString stringWithFormat: @"%i", [self.itemToEdit.targetGrade intValue]];
        self.target = [self.itemToEdit.targetGrade intValue];
        
        self.colour = self.itemToEdit.colour;
        self.colourView.backgroundColor = self.itemToEdit.colour;
        
        if (CGColorGetNumberOfComponents(self.itemToEdit.colour.CGColor) >= 3) {
            const CGFloat *colourComponents = CGColorGetComponents(self.itemToEdit.colour.CGColor);
            self.redSlider.value = colourComponents[0];
            self.greenSlider.value = colourComponents[1];
            self.blueSlider.value = colourComponents[2];
        }
        
        self.teacherNameField.text = self.itemToEdit.teacherName;
        self.teacherEmailField.text = self.itemToEdit.teacherEmail;
        
    } else {
        // Assign a random colour to new items
        float red = arc4random() / (double)ARC4_RAND_MAX;
        float green = arc4random() / (double)ARC4_RAND_MAX;
        float blue = arc4random() / (double)ARC4_RAND_MAX;
        self.colour = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        
        self.redSlider.value = red;
        self.greenSlider.value = green;
        self.blueSlider.value = blue;
        self.colourView.backgroundColor = self.colour;
    }
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Open the keyboard automatically when the view appears
    [self.nameField becomeFirstResponder];
}


- (BOOL) isEnteredDataValid {
    //Check for the presence of a name
    if ([self.nameField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide a name" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the name length is less than 30
    if ([self.nameField.text length] > 30) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The name must be less than 30 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check for weighting value
    if ([self.weightingField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide a year weighting" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check weighting is between 0 and 100%
    if ([self.weightingField.text floatValue] < 0 || [self.weightingField.text floatValue] > 100) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The year weighting must be 0-100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check for target value
    if ([self.targetField.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"You must provide a target grade" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check target is between 0 and 100%
    if ([self.targetField.text intValue] < 0 || [self.targetField.text intValue] > 100) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The target grade must be 0-100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the teacher name length is less than 20
    if ([self.teacherNameField.text length] > 20) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The teacher name must be less than 20 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the teacher email length is less than 50
    if ([self.teacherEmailField.text length] > 50) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The teacher email must be less than 50 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the weighting for this subject is permissible given weightings for other subjects
    if ([self.weightingField.text floatValue] + self.weightingAllocated > 100) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The year weighting is too high. The weighting for all subjects in a year should total 100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    return true;
}


// Called when the done navigation bar button is pressed
- (IBAction)done {
    // Validate the input data
    if (![self isEnteredDataValid]) {return;}
    
    if (self.itemToEdit != nil) {
        // If editing, update the item and call the delegate method to dismiss the view
        self.itemToEdit.name = self.nameField.text;
        self.itemToEdit.yearWeighting = [NSNumber numberWithFloat:[self.weightingField.text floatValue]];
        self.itemToEdit.targetGrade = [NSNumber numberWithInt:[self.targetField.text intValue]];
        self.itemToEdit.colour = self.colour;
        self.itemToEdit.teacherName = self.teacherNameField.text;
        self.itemToEdit.teacherEmail = self.teacherEmailField.text;
        
        [self.delegate SubjectDetailTableViewController:self didFinishEditingSubject:self.itemToEdit];
        
    } else {
        // If adding, create a new item and call the delegate method to dismiss the view
        Subject *newSubject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:self.managedObjectContext];
        newSubject.name = self.nameField.text;
        newSubject.yearWeighting = [NSNumber numberWithFloat:[self.weightingField.text floatValue]];
        newSubject.targetGrade = [NSNumber numberWithInt: [self.targetField.text intValue]];
        newSubject.colour = self.colour;
        newSubject.teacherName = self.teacherNameField.text;
        newSubject.teacherEmail = self.teacherEmailField.text;
        
        [self.delegate SubjectDetailTableViewController:self didFinishAddingSubject: newSubject];
    }
}


// Called when the cancel navigation bar button is pressed
- (IBAction)cancel {
    // Delegate method when the cancel button is pressed
    [self.delegate SubjectDetailTableViewControllerDidCancel:self];
}


- (IBAction)colourSliderChanged {
    self.colour = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0f];
    self.colourView.backgroundColor = self.colour;
}


#pragma mark - UITextFieldDelegate

// When the text field changes, check that the new character is valid
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        //If weighting field
        case 1:
            return ([newText length] < 3 || [newText isEqual: @"100"] || [newText isEqual: @"100."] || [newText isEqual: @"100.0"] || [newText isEqual: @"100.00"] || ([newText characterAtIndex:2] == '.' && [newText length] < 6) || ([newText characterAtIndex:1] == '.' && [newText length] < 5));
            break;
        //If target field
        case 2: return ([newText length] < 3 || [newText isEqual: @"100"]); break;
        //Otherwise
        default: return YES;
    }
}


// When the user finishes with a textfield, ensure the contents are in the correct format
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        //If grade field
        case 1: textField.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]]; break;
        //If rating field
        case 2: textField.text = [NSString stringWithFormat:@"%i", [textField.text intValue]]; break;
        //Otherwise
        default: return;
    }
}


@end

