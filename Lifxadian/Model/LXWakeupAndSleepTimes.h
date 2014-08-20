//
//  LXWakeupAndSleepTimes.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoundationMacros.h"

@interface LXWakeupAndSleepTimes : NSObject
@property (nonatomic, readwrite) NSTimeInterval sleepTime;
@property (nonatomic, readwrite) NSTimeInterval wakeTime;
@property (nonatomic, readwrite) NSTimeInterval weekendSleepTime;
@property (nonatomic, readwrite) NSTimeInterval weekendWakeTime;
@end

SINGLETON_INTERFACE(LXWakeupAndSleepTimes)