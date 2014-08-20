//
//  LXGradientView.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/22/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientView.h"
#import "LXGradientInfo.h"
#import "LXGradientTime.h"
#import "LFXHSBKColor+UIColor.h"
#import "LFXHSBKColor.h"
#import "LXGradientLocationIndicatorView.h"

@interface LXGradientView ()
@property (nonatomic, strong) UIButton *sunriseButton;
@property (nonatomic, strong) UIButton *noonButton;
@property (nonatomic, strong) UIButton *sunsetButton;
@property (nonatomic, strong) NSMutableArray *indicators;
@end

@implementation LXGradientView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicators = [NSMutableArray array];
        // Initialization code
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.indicators = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithGradientInfo:(LXGradientInfo *)info {
    if (self = [super init]) {
        self.gradientInfo = info;
        self.indicators = [NSMutableArray array];
    }
    return self;
}


- (void)setGradientInfo:(LXGradientInfo *)gradientInfo {
    _gradientInfo = gradientInfo;
    
    //remove old indicators
    for (UIView *view in self.indicators) {
        [view removeFromSuperview];
    }
    
    [self.indicators removeAllObjects];
    
    if (_gradientInfo == nil) {
        return;
    }
    
    NSArray *sortedGradientInfo = [gradientInfo sortedColorsAndTimes];
    
    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:sortedGradientInfo.count];
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:sortedGradientInfo.count];
    
    for (NSDictionary *dict in sortedGradientInfo) {
        LFXHSBKColor *lcolor = dict[@"color"];
        UIColor *color = [lcolor UIColor];
        LXGradientTime *time = dict[@"time"];
        
        CGFloat percentTime = [time timeIntervalSinceMidnight] / (3600.0 * 24);
        
        if (_topMargin > 0) {
            percentTime += _topMargin/self.frame.size.height;
        }
        
        if (_bottomMargin > 0) {
            percentTime -= _bottomMargin/self.frame.size.height;
        }
        
        NSLog(@"At %2.2f, color: %@", percentTime, color);
        
        [colors addObject:color];
        [locations addObject:@(percentTime)];
    }
    
    if (_topMargin > 0) {
        [colors insertObject:colors[0] atIndex:0];
        [locations insertObject:@(0.0) atIndex:0];
    }
    
    if (_bottomMargin > 0) {
        [colors addObject:colors[colors.count-1]];
        [locations addObject:@(1.0)];
    }
    
    
    self.gradientDirection = SAMGradientViewDirectionHorizontal;
    
    self.gradientLocations = locations;
    self.gradientColors = colors;
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.indicators.count == 0) {
        [self addLocationIndicators];
    }
}
#pragma mark -

static CGFloat indicatorWidth = 100.0;
static CGFloat indicatorHeight = 20.0;

- (UIView *)locationIndicatorAtLocation:(CGFloat)location color:(UIColor *)color {
    LXGradientLocationIndicatorView *view = [[LXGradientLocationIndicatorView alloc] initWithFrame:CGRectMake(0, 0, indicatorWidth, indicatorHeight)];
    view.color = color;
    
    CGFloat cy = _topMargin + 3600 * location;
    CGFloat cx = MAX(self.frame.size.width - indicatorWidth, 0);

    view.center = CGPointMake(cx, cy);
    
    return view;
}

- (void)addLocationIndicators {
    
    //remove old ones
    for (UIView *view in self.indicators) {
        [view removeFromSuperview];
    }
    
    [self.indicators removeAllObjects];
    
    for (int i = 0; i < self.gradientLocations.count; i++) {
        UIView *indicatorView = [self locationIndicatorAtLocation:[self.gradientLocations[i] floatValue] color:self.gradientColors[i]];
        [self.indicators addObject:indicatorView];
        [self addSubview:indicatorView];
    }
}

#pragma mark -
- (void)setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
    [self setGradientInfo:_gradientInfo];
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    [self setGradientInfo:_gradientInfo];
}

- (UIButton *)buttonWithImage:(NSString *)imageName title:(NSString *)title color:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTintColor:color];
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    return button;
}

- (void)createButtons {
    
}

- (void)updateLabels {
    
}

@end
