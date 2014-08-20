//
//  LXGradientInfoTableViewCell.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/27/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXGradientInfo;

@interface LXGradientInfoTableViewCell : UITableViewCell
+ (instancetype)cell;

@property (nonatomic, strong) LXGradientInfo *gradientInfo;
@end
