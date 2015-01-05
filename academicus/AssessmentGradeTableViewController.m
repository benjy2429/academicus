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
//    self.ratingStar2.titleLabel.text = (rating > 1) ? @"★" : @"☆";
//    self.ratingStar3.titleLabel.text = (rating > 2) ? @"★" : @"☆";
//    self.ratingStar4.titleLabel.text = (rating > 3) ? @"★" : @"☆";
//    self.ratingStar5.titleLabel.text = (rating > 4) ? @"★" : @"☆";
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
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"The final grade must be 0-100%" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    // Validate that the final grade is between 0% and 100%
    if (self.currentRating < 1 || self.currentRating > 5) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"You must provide a rating" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
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
    return nil;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //If grade field
    if (textField.tag == 001) {
        return ([newText length] < 3 || [newText isEqual: @"100"] || ([newText characterAtIndex:2] == '.' && [newText length] < 6) || ([newText characterAtIndex:1] == '.' && [newText length] < 5));
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


@end
