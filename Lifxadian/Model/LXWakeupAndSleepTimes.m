//
//  LXWakeupAndSleepTimes.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXWakeupAndSleepTimes.h"
#import "NSDate+Extensions.h"

static NSString *const kSleepTimeKey = @"Sleep Time";
static NSString *const kWakeTimeKey = @"Wake Time";
static NSString *const kWeekendSleepTimeKey = @"Weekend Sleep Time";
static NSString *const kWeekendWakeTimeKey = @"Weekend Wake Time";


SINGLETON_IMPLEMENTATION(LXWakeupAndSleepTimes)
@implementation LXWakeupAndSleepTimes

- (void)setSleepTime:(NSTimeInterval)sleepTime {
    [[NSUserDefaults standardUserDefaults] setValue:@(sleepTime) forKey:kSleepTimeKey];
}

- (void)setWakeTime:(NSTimeInterval)wakeTime {
    [[NSUserDefaults standardUserDefaults] setValue:@(wakeTime) forKey:kWakeTimeKey];
}

- (void)setWeekendSleepTime:(NSTimeInterval)sleepTime {
    [[NSUserDefaults standardUserDefaults] setValue:@(sleepTime) forKey:kWeekendSleepTimeKey];
}

- (void)setWeekendWakeTime:(NSTimeInterval)wakeTime {
    [[NSUserDefaults standardUserDefaults] setValue:@(wakeTime) forKey:kWeekendWakeTimeKey];
}



- (NSTimeInterval)wakeTime {
    return [self prefTimeIntervalForKey:kWakeTimeKey defaultValue:TIMEINTERVAL(8, 0)];
}

- (NSTimeInterval)sleepTime {
    return [self prefTimeIntervalForKey:kWakeTimeKey defaultValue:TIMEINTERVAL(23, 0)];
}

- (NSTimeInterval)weekendWakeTime {
    return [self prefTimeIntervalForKey:kWakeTimeKey defaultValue:TIMEINTERVAL(8, 0)];
}

- (NSTimeInterval)weekendSleepTime {
    return [self prefTimeIntervalForKey:kWakeTimeKey defaultValue:TIMEINTERVAL(23, 0)];
}

#pragma mark -
- (NSTimeInterval)prefTimeIntervalForKey:(NSString *)key defaultValue:(NSTimeInterval)defaultValue {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] ? [[NSUserDefaults standardUserDefaults] doubleForKey:key] : defaultValue;
}
@end
