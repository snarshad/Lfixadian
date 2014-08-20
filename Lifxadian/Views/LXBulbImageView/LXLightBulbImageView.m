//
//  UILightBulbImageView.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/20/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXLightBulbImageView.h"
#import "UIImage+Tint.h"
#import <LIFXKit/LIFXKit.h>
#import "UIColor+LFXExtensions.h"

@implementation LXLightBulbImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.image = [UIImage imageNamed:@"lightbulb"];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    NSLog(@"Color: %@", color);
    self.image = [[UIImage imageNamed:@"lightbulb"] imageTintedWithColor:color];
}

@end
