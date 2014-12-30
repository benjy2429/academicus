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
    
    self.positiveFeedbackField.text = POSITIVE_FEEDBACK_PLACEHOLDER;
    self.negativeFeedbackField.text = NEGATIVE_FEEDBACK_PLACEHOLDER;
    self.notesField.text = NOTES_PLACEHOLDER;
    
    if (self.itemToEdit.hasGrade) {
        self.gradeField.text = [NSString stringWithFormat:@"%.2f", [self.itemToEdit.finalGrade floatValue]];
        self.ratingField.text = (self.itemToEdit.rating != 0) ? [NSString stringWithFormat:@"%d", [self.itemToEdit.rating intValue]] : @"";
        
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
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Open the keyboard automatically when the view appears
    [self.gradeField becomeFirstResponder];
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
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"The final grade must be 0-100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    // Validate that the rating is between 1 and 5
    if (![self.ratingField.text isEqualToString:@""] && ([self.ratingField.text intValue] < 1 || [self.ratingField.text intValue] > 5)) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"The assessment raitng must be between 1-5" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the positive feedback length is less than 300
    if ([self.positiveFeedbackField.text length] > 300) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"The positive feedback must be less than 300 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the negative feedback length is less than 300
    if ([self.positiveFeedbackField.text length] > 300) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"The negaitve feedback must be less than 300 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the notes is less than 300
    if ([self.positiveFeedbackField.text length] > 300) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"The notes field must be less than 300 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
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
    self.itemToEdit.rating = (![self.ratingField.text isEqualToString:@""]) ? [NSNumber numberWithInt:[self.ratingField.text intValue]] : 0;
    self.itemToEdit.positiveFeedback = (![self.positiveFeedbackField.text isEqualToString:POSITIVE_FEEDBACK_PLACEHOLDER]) ? self.positiveFeedbackField.text : @"";
    self.itemToEdit.negativeFeedback = (![self.negativeFeedbackField.text isEqualToString:NEGATIVE_FEEDBACK_PLACEHOLDER]) ? self.negativeFeedbackField.text : @"";
    self.itemToEdit.notes = self.notesField.text;
    //self.itemToEdit.picture =
    
    [self.delegate AssessmentGradeTableViewController:self didFinishEditingAssessment:self.itemToEdit];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disable the ability to select table rows
    return nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        //If grade field
        case 001:
            return ([newText length] < 3 || [newText isEqual: @"100"] || ([newText characterAtIndex:2] == '.' && [newText length] < 6) || ([newText characterAtIndex:1] == '.' && [newText length] < 5));
            break;
        //If rating field
        case 101:
            return ([self.ratingField.text intValue] > 0 && [self.ratingField.text intValue] < 6);
            break;
        //Otherwise
        default:
            return YES;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        //If grade field
        case 001:
            textField.text = [NSString stringWithFormat:@"%.2f", [textField.text floatValue]];
            break;
            //If rating field
        case 201:
            textField.text = [NSString stringWithFormat:@"%i", [textField.text intValue]];
            break;
        //Otherwise
        default:
            return;
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


@end
