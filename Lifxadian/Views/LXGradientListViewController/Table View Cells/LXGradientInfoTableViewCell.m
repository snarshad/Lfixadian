//
//  LXGradientInfoTableViewCell.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/27/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientInfoTableViewCell.h"
#import "LXGradientView.h"
#import "LXGradientInfo.h"
#import <CoreGraphics/CoreGraphics.h>
#import "SAMGradientView.h"

@interface LXGradientInfoTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *gradientNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *gradientInfoLabel;
@property (strong, nonatomic) IBOutlet LXGradientView *gradientView;
@property (strong, nonatomic) IBOutlet SAMGradientView *overlayView;

@end

@implementation LXGradientInfoTableViewCell

+ (instancetype)cell {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    LXGradientInfoTableViewCell *cell = (LXGradientInfoTableViewCell *)[nib objectAtIndex:0];
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
    [self addOverlay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGradientInfo:(LXGradientInfo *)gradientInfo {
    _gradientInfo = gradientInfo;
    [self updateView];
    
}

#pragma mark view updating
- (void)updateView {
    self.gradientInfoLabel.text = self.gradientInfo.description;
    self.gradientNameLabel.text = self.gradientInfo.name;
    self.gradientView.gradientInfo = self.gradientInfo;
}

- (void)addOverlay {
    self.overlayView.gradientLocations = @[@(0.5), @(1.0)];
    NSArray *overlayGradientColors = @[[UIColor colorWithWhite:0.0 alpha:1.0], [UIColor colorWithWhite:0.0 alpha:0.0]];
    self.overlayView.gradientColors = overlayGradientColors;
}

@end
