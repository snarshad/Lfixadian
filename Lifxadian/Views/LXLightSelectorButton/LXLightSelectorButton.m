//
//  LXLightSelectorButton.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/20/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXLightSelectorButton.h"
#import "LXLightManager.h"

@interface LXLightSelectorButton ()
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation LXLightSelectorButton

- (void)commonViewInit {
    CGRect frame = self.bounds;
    [self setTitleColor:self.tintColor forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:@"LifxIcon_color"] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -((frame.size.height * 2) + 2), 0, frame.size.height + 2);
    self.imageEdgeInsets = UIEdgeInsetsMake (0, frame.size.width - (frame.size.height + 2), 0, 0);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonViewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonViewInit];
    }
    return self;
}


@end
