//
//  AssessementsOnTargetCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "AssessmentsOnTargetCell.h"

//Constant defining the animation duration
const float ASSESSMENTS_ON_TARGET_DURATION = 1.5f;

@implementation AssessmentsOnTargetCell


- (void)awakeFromNib {}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//Configure the cell with the number of assessmentst that have been graded and how many of them were on target
- (void) configureCellWithMetTarget:(int)assessmentsOnTarget gradedAssessments: (int) assessmentsGraded {
    //Reset the view
    [self.offTargetCircle removeFromSuperlayer];
    [self.onTargetCircle removeFromSuperlayer];
    
    //Calculate the fraction of assessments on target
    self.onTargetAmount = (assessmentsGraded == 0) ? 0 : assessmentsOnTarget/(float)assessmentsGraded;
    
    //Increment the value in the label from zero to the percentage of assessments on target by using an NSTimer
    self.currentLabelValue = 0;
    [self updateLabel];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: (ASSESSMENTS_ON_TARGET_DURATION/(self.onTargetAmount*100)) target:self selector:@selector(updateLabel) userInfo:nil repeats: YES];
    
    //Draw a pie chart showing the ratio of assessments on target to not on target
    [self drawPieChart];
    
    //Add the percentage amount as a label to the view also
    [self.percentageOnTargetLabel.superview bringSubviewToFront:self.percentageOnTargetLabel];
}


//Updates the label on screen
- (void) updateLabel {
    self.percentageOnTargetLabel.text = [NSString stringWithFormat: @"%i%%", self.currentLabelValue];
    
    //If we have reached the final value, invalidate the timer and stop or increase the current value for the next iteration
    if (self.currentLabelValue == (int) (self.onTargetAmount*100)) {
        [self.timer invalidate];
    } else {
        self.currentLabelValue++;
    }
}


//Draw a pie chart showing the ratio of assessments on target to not on target
- (void) drawPieChart {
    UIView* view = self.percentageOnTargetLabel.superview;

    //Use the app tint colours to colour the pie chart
    self.offTargetCircle = [self makeCircleWithColour:[APP_TINT_COLOUR colorWithAlphaComponent:0.5]];
    self.onTargetCircle = [self makeCircleWithColour:APP_TINT_COLOUR];
    
    // Add circles to layer
    [view.layer addSublayer:self.offTargetCircle];
    [view.layer addSublayer:self.onTargetCircle];
    
    // Add the animation to the circle
    [self.offTargetCircle addAnimation:[self generateAnimationWithFillAmount:(float) 1.0] forKey:@"drawOffTarget"];
    [self.onTargetCircle addAnimation:[self generateAnimationWithFillAmount:(float) self.onTargetAmount] forKey:@"drawOnTarget"];

}

- (CAShapeLayer*) makeCircleWithColour: (UIColor*) colour {
    UIView* view = self.percentageOnTargetLabel.superview;

    int radius = 32;
    //Create a circle shape
    CAShapeLayer* circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,2.0*radius, 2.0*radius) cornerRadius: radius].CGPath;
    circle.position = CGPointMake((0.5*view.frame.size.width) + 75 - radius, (0.5*view.frame.size.height) - radius);
    
    //Configure the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = colour.CGColor;
    circle.lineWidth = 15;
    
    return circle;
}


//Animate the circles to make pie segments
- (CABasicAnimation*)generateAnimationWithFillAmount:(float) fillAmount {
    //Initialise animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = ASSESSMENTS_ON_TARGET_DURATION;
    drawAnimation.repeatCount = 1.0;
    
    //Draw the circle up until the fill amount and then stop
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:fillAmount];
    drawAnimation.removedOnCompletion = NO;
    drawAnimation.fillMode = kCAFillModeForwards;
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return drawAnimation;
}

@end
