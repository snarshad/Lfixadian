//
//  LXGradientInfo.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LXGradientTime;

@interface LXGradientInfo : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *gradientDescription;
@property (nonatomic, strong) NSMutableArray *colorsByTime; /* keys are LXGradientTimes, values are UIColors */

- (void)addColor:(id)color forTime:(LXGradientTime *)time;
- (void)saveToDisk;

- (NSArray *)sortedColorsAndTimes;

@end
