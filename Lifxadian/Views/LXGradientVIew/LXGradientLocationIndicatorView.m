//
//  LXGradientLocationIndicatorView.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 8/20/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientLocationIndicatorView.h"

@implementation LXGradientLocationIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}





// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();

    CGFloat circleRadius = self.frame.size.height / 2;
    CGFloat lineLength = self.frame.size.width - (circleRadius * 2);
    CGFloat yCenter =  self.frame.size.height / 2;
    
    CGFloat black[4] = {0, 0, 0, 1};
    CGContextSetStrokeColor(c, black);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0, yCenter);
    CGContextAddLineToPoint(c, lineLength, yCenter);
    CGContextStrokePath(c);
}

@end
