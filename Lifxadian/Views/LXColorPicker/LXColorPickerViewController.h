//
//  LXColorPickerViewController.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/23/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"

@protocol LXColorPickerViewControllerDelegate <NSObject>
- (void)didChooseColor:(UIColor *)color;
@optional
- (void)didSwipeToColor:(UIColor *)color;
@end

@interface LXColorPickerViewController : UIViewController
@property (nonatomic, strong) UIColor *startColor;
@property (weak) id<LXColorPickerViewControllerDelegate>delegate;
- (instancetype)initWithStartColor:(UIColor *)startColor delegate:(id<LXColorPickerViewControllerDelegate>)delegate;
- (void)resetToStartColor;
@end
