//
//  LFXHSBKColor+UIColor.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LFXHSBKColor+UIColor.h"

@implementation LFXHSBKColor (UIColor)
+ (LFXHSBKColor *)colorWithUIColor:(UIColor *)color {
    CGFloat hue, saturation, brightness, alpha;
    
    if (![color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        NSLog(@"FAILED to convert color: %@", color);
        return nil;
    }
    
    //    NSLog(@"Hue: %3.2f, sat: %3.2f, br: %3.2f alpha: %3.2f", hue, saturation, brightness, alpha);
    
    LFXHSBKColor *lColor = [LFXHSBKColor colorWithHue:hue  * 360.0f saturation:saturation brightness:brightness];
    return lColor;
}

@end

@implementation UIColor (LFXHSBKColor)
- (LFXHSBKColor *)LFXHSBKColor {
    return [LFXHSBKColor colorWithUIColor:self];
}
@end
