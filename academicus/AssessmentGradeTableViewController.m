//
//  AssessmentGradeTableViewController.m
//  academicus
//
//  Created by Luke on 22/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AssessmentGradeTableViewController.h"

@implementation AssessmentGradeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.ratingStar1 setTitleColor: APP_TINT_COLOUR forState: UIControlStateNormal];
    [self.ratingStar2 setTitleColor: APP_TINT_COLOUR forState: UIControlStateNormal];
    [self.ratingStar3 setTitleColor: APP_TINT_COLOUR forState: UIControlStateNormal];
    [self.ratingStar4 setTitleColor: APP_TINT_COLOUR forState: UIControlStateNormal];
    [self.ratingStar5 setTitleColor: APP_TINT_COLOUR forState: UIControlStateNormal];
    
    self.positiveFeedbackField.text = POSITIVE_FEEDBACK_PLACEHOLDER;
    self.negativeFeedbackField.text = NEGATIVE_FEEDBACK_PLACEHOLDER;
    self.notesField.text = NOTES_PLACEHOLDER;
    self.currentRating = 0;

    if ([self.itemToEdit.hasGrade boolValue]) {
        self.title = @"Edit Grade";
        
        self.gradeField.text = [NSString stringWithFormat:@"%.2f", [self.itemToEdit.finalGrade floatValue]];
        [self setRating: ((self.itemToEdit.rating != 0) ? [self.itemToEdit.rating intValue] : 0)];
        self.currentRating = ((self.itemToEdit.rating != 0) ? [self.itemToEdit.rating intValue] : 0);
        
        if (![self.itemToEdit.positiveFeedback isEqualToString:@""]) {
            self.positiveFeedbackField.text = self.itemToEdit.positiveFeedback;
            self.positiveFeedbackField.textColor = [UIColor blackColor];
        }
        if (![self.itemToEdit.negativeFeedback isEqualToString:@""]) {
            self.negativeFeedbackField.text = self.itemToEdit.negativeFeedback;
            self.negativeFeedbackField.textColor = [UIColor blackColor];
        }
        if (![self.itemToEdit.notes isEqualToString:@""]) {
            self.notesField.text = self.itemToEdit.notes;
            self.notesField.textColor = [UIColor blackColor];
        }
        
        // self.pictureField.text = self.itemToEdit.picture;
        
    }
    
    //Add a gesture recognizer to detect left swipes on the rating cell
    UISwipeGestureRecognizer* ratingLeftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRatingLeftSwipe)];
    ratingLeftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    ratingLeftSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.ratingCell addGestureRecognizer:ratingLeftSwipeRecognizer];
    
    //Add a gesture recognizer to detect right swipes on the rating cell
    UISwipeGestureRecognizer* ratingRightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRatingRightSwipe)];
    ratingRightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    ratingRightSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.ratingCell addGestureRecognizer:ratingRightSwipeRecognizer];
}


//Called when a left swipe is detected
- (void) handleRatingLeftSwipe
{
    if (self.currentRating > 0) {[self setRating:self.currentRating - 1];} //Providing at least one star has been given, reduce the current rating

}


//Called when a right swipe is detected
- (void) handleRatingRightSwipe
{
    if (self.currentRating < 5) {[self setRating:self.currentRating + 1];} //Proviging no more than five stats have been given, increase the current rating

}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Open the keyboard automatically when the view appears
    [self.gradeField becomeFirstResponder];
}


- (IBAction)starPressed:(UIButton*)starButton {
    switch (starButton.tag) {
        case 101 : [self setRating:1]; break;
        case 102 : [self setRating:2]; break;
        case 103 : [self setRating:3]; break;
        case 104 : [self setRating:4]; break;
        case 105 : [self setRating:5]; break;
        default : [self setRating:0];
    }
}

- (void) setRating: (int)rating {
    [self.ratingStar1 setTitle:((rating > 0) ? @"★" : @"☆") forState: UIControlStateNormal];
    [self.ratingStar2 setTitle:((rating > 1) ? @"★" : @"☆") forState: UIControlStateNormal];
    [self.ratingStar3 setTitle:((rating > 2) ? @"★" : @"☆") forState: UIControlStateNormal];
    [self.ratingStar4 setTitle:((rating > 3) ? @"★" : @"☆") forState: UIControlStateNormal];
    [self.ratingStar5 setTitle:((rating > 4) ? @"★" : @"☆") forState: UIControlStateNormal];
    self.currentRating = rating;
}

- (IBAction)cancel
{
    // Delegate method when the cancel button is pressed
    [self.delegate AssessmentGradeTableViewControllerDidCancel:self];
}


- (BOOL) isEnteredDataValid
{
    // Validate that the final grade is between 0% and 100%
    if ([self.gradeField.text floatValue] < 0 || [self.gradeField.text floatValue] > 100) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The final grade must be 0-100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the positive feedback length is less than 300
    if ([self.positiveFeedbackField.text length] > 300) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The positive feedback must be less than 300 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the negative feedback length is less than 300
    if ([self.positiveFeedbackField.text length] > 300) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The negaitve feedback must be less than 300 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the notes is less than 300
    if ([self.positiveFeedbackField.text length] > 300) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The notes field must be less than 300 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    return true;
}


- (IBAction)done
{
    if (![self isEnteredDataValid]) {return;}
    
    // If editing, update the item and call the delegate method to dismiss the view
    self.itemToEdit.hasGrade = [NSNumber numberWithBool:YES];
    self.itemToEdit.finalGrade = [NSNumber numberWithFloat:[self.gradeField.text floatValue]];
    self.itemToEdit.rating = [NSNumber numberWithInt: self.currentRating];
    self.itemToEdit.positiveFeedback = (![self.positiveFeedbackField.text isEqualToString:POSITIVE_FEEDBACK_PLACEHOLDER]) ? self.positiveFeedbackField.text : @"";
    self.itemToEdit.negativeFeedback = (![self.negativeFeedbackField.text isEqualToString:NEGATIVE_FEEDBACK_PLACEHOLDER]) ? self.negativeFeedbackField.text : @"";
    self.itemToEdit.notes = (![self.notesField.text isEqualToString:NOTES_PLACEHOLDER]) ? self.notesField.text : @"";
    //self.itemToEdit.picture =
    
    [self.delegate AssessmentGradeTableViewController:self didFinishEditingAssessment:self.itemToEdit];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable the ability to select table rows
    return (indexPath.section == 1 || indexPath.section == 4) ? indexPath : nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //If grade field
    if (textField.tag == 001) {
        return ([newText length] < 3 || [newText isEqual: @"100"] || [newText isEqual: @"100."] || [newText isEqual: @"100.0"] || [newText isEqual: @"100.00"] || ([newText characterAtIndex:2] == '.' && [newText length] < 6) || ([newText characterAtIndex:1] == '.' && [newText length] < 5));
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //If grade field
    if (textField.tag == 001) {
        textField.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
    }
}


// Remove placeholder text for UITextView elements
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 201 && [textView.text isEqualToString:POSITIVE_FEEDBACK_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    } else if (textView.tag == 202 && [textView.text isEqualToString:NEGATIVE_FEEDBACK_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    } else if (textView.tag == 203 && [textView.text isEqualToString:NOTES_PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [textView becomeFirstResponder];
}


// Set placeholder text for UITextView elements
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 201 && [textView.text isEqualToString:@""]) {
        textView.text = POSITIVE_FEEDBACK_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor];
    } else if (textView.tag == 202 && [textView.text isEqualToString:@""]) {
        textView.text = NEGATIVE_FEEDBACK_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor];
    } else if (textView.tag == 203 && [textView.text isEqualToString:@""]) {
        textView.text = NOTES_PLACEHOLDER;
        textView.textColor = [UIColor lightGrayColor];
    }
    
    [textView resignFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check if the remove grade button was pressed
    if (indexPath.section == 4) {
        // Remove all the grade information
        self.itemToEdit.hasGrade = [NSNumber numberWithBool:NO];
        self.itemToEdit.finalGrade = nil;
        self.itemToEdit.rating = nil;
        self.itemToEdit.positiveFeedback = nil;
        self.itemToEdit.negativeFeedback = nil;
        self.itemToEdit.notes = nil;
        //self.itemToEdit.picture =
        
        [self.delegate AssessmentGradeTableViewController:self didFinishEditingAssessment:self.itemToEdit];
        
    // Check if the rating field was pressed
    } else if (indexPath.section == 1) {
        [self setRating:0];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([self.itemToEdit.hasGrade boolValue]) ? [super numberOfSectionsInTableView:tableView] : [super numberOfSectionsInTableView:tableView] - 1;
}


@end
