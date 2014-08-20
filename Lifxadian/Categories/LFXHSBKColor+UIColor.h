//
//  LFXHSBKColor+UIColor.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFXHSBKColor.h"

@interface UIColor (LFXHSBKColor)
- (LFXHSBKColor *)LFXHSBKColor;
@end

@interface LFXHSBKColor (UIColor)
+ (LFXHSBKColor *)colorWithUIColor:(UIColor *)color;
@end
