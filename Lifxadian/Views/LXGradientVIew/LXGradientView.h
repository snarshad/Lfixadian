//
//  LXGradientView.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/22/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "SAMGradientView.h"

@class LXGradientInfo;

@interface LXGradientView : SAMGradientView
@property (nonatomic, strong) LXGradientInfo *gradientInfo;
@property (nonatomic, readwrite) CGFloat topMargin;
@property (nonatomic, readwrite) CGFloat bottomMargin;
@end
