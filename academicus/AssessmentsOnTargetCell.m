//
//  AssessementsOnTargetCell.m
//  academicus
//
//  Created by Luke on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "AssessmentsOnTargetCell.h"
const float ASSESSMENTS_ON_TARGET_DURATION = 1.5f;

@implementation AssessmentsOnTargetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithMetTarget:(int)assessmentsOnTarget gradedAssessments: (int) assessmentsGraded
{
    [self.offTargetCircle removeFromSuperlayer];
    [self.onTargetCircle removeFromSuperlayer];
    
    self.onTargetAmount = assessmentsOnTarget/(float)assessmentsGraded;
    self.currentLabelValue = 0;
    [self updateLabel];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: (ASSESSMENTS_ON_TARGET_DURATION/(self.onTargetAmount*100)) target:self selector:@selector(updateLabel) userInfo:nil repeats: YES];
    
    [self drawPieChart];
    [self.percentageOnTargetLabel.superview bringSubviewToFront:self.percentageOnTargetLabel];
}

- (void) updateLabel {
    self.percentageOnTargetLabel.text = [NSString stringWithFormat: @"%i%%", self.currentLabelValue];
    if (self.currentLabelValue == (int) (self.onTargetAmount*100)) {
        [self.timer invalidate];
    } else {
        self.currentLabelValue++;
    }
}

- (void) drawPieChart {
    UIView* view = self.percentageOnTargetLabel.superview;

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
    CAShapeLayer* circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,2.0*radius, 2.0*radius) cornerRadius: radius].CGPath;
    circle.position = CGPointMake((0.5*view.frame.size.width) + 75 - radius, (0.5*view.frame.size.height) - radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = colour.CGColor;
    circle.lineWidth = 15;
    return circle;
}

- (CABasicAnimation*)generateAnimationWithFillAmount:(float) fillAmount {
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = ASSESSMENTS_ON_TARGET_DURATION;
    drawAnimation.repeatCount = 1.0;
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:fillAmount];
    drawAnimation.removedOnCompletion = NO;
    
    drawAnimation.fillMode = kCAFillModeForwards;
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return drawAnimation;
}

@end
