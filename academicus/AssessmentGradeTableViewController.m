//
//  AssessmentGradeTableViewController.m
//  academicus
//
//  Created by Luke on 22/12/2014.
//  Copyright (c) 2014 sheffield. All rights reserved.
//

#import "AssessmentGradeTableViewController.h"

@interface AssessmentGradeTableViewController ()

@end

@implementation AssessmentGradeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.positiveFeedbackField.text = POSITIVE_FEEDBACK_PLACEHOLDER;
    self.negativeFeedbackField.text = NEGATIVE_FEEDBACK_PLACEHOLDER;
    
    if (self.itemToEdit.hasGrade) {
        self.gradeField.text = [NSString stringWithFormat:@"%.2f", self.itemToEdit.finalGrade];
        self.ratingField.text = (self.itemToEdit.rating != 0) ? [NSString stringWithFormat:@"%d", self.itemToEdit.rating] : @"";
        
        if (![self.itemToEdit.positiveFeedback isEqualToString:@""]) {
            self.positiveFeedbackField.text = self.itemToEdit.positiveFeedback;
            self.positiveFeedbackField.textColor = [UIColor blackColor];
        }
        if (![self.itemToEdit.negativeFeedback isEqualToString:@""]) {
            self.negativeFeedbackField.text = self.itemToEdit.negativeFeedback;
            self.negativeFeedbackField.textColor = [UIColor blackColor];
        }
        
        self.notesField.text = self.itemToEdit.notes;
        // self.pictureField.text = self.itemToEdit.picture;
        
    } else {
        self.doneBtn.enabled = NO;
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


- (IBAction)done
{
    // Validate that the final grade is between 0% and 100%
    if ([self.gradeField.text floatValue] < 0 || [self.gradeField.text floatValue] > 100) {
        [self.gradeField setTextColor:[UIColor redColor]];
        return;
    }
    
    // Validate that the rating is between 1 and 5
    if (![self.ratingField.text isEqualToString:@""] && ([self.ratingField.text intValue] <= 0 || [self.ratingField.text floatValue] > 5)) {
        [self.ratingField setTextColor:[UIColor redColor]];
        return;
    }
    
    // If editing, update the item and call the delegate method to dismiss the view
    self.itemToEdit.hasGrade = YES;
    self.itemToEdit.finalGrade = [self.gradeField.text floatValue];
    self.itemToEdit.rating = (![self.ratingField.text isEqualToString:@""]) ? [self.ratingField.text intValue] : 0;
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
    // Only enable the done button when the grade field is not empty
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 100) {
        self.doneBtn.enabled = ([newText length] > 0);
    }
    
    return YES;
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
    }
    
    [textView resignFirstResponder];
}


@end
