//
//  LXGradientTime.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEINTERVAL_ONE_HOUR (3600)

@interface LXGradientTime : NSObject <NSCoding, NSCopying>

/**
 *  Return a time that will be dynamically resolved to sunrise
 *
 *  @return LXGradientTime that will be dynamically resolved to sunrise
 */
+ (LXGradientTime *)sunriseTime;

/**
 *  Return a time that will be dynamically resolved to sunset
 *
 *  @return LXGradientTime that will be dynamically resolved to sunset
 */
+ (LXGradientTime *)sunsetTime;

/**
 *  Return a time that will be dynamically resolved to sunset
 *
 *  @return LXGradientTime that will be dynamically resolved to midday
 */
+ (LXGradientTime *)middayTime;

/**
 *  Specifiy a time relative to sunrise
 *
 *  @param timeoffset seconds after sunrise
 *
 *  @return LXGradientTime that can be resolved dynamically to sunrise
 */
+ (LXGradientTime *)sunriseTimeWithOffset:(NSTimeInterval)timeoffset;

/**
 *  Specifiy a time relative to sunrise
 *
 *  @param timeoffset seconds after sunrise
 *
 *  @return LXGradientTime that can be resolved dynamically to sunrise
 */
+ (LXGradientTime *)sunsetTimeWithOffset:(NSTimeInterval)timeoffset;

/**
 *  Specifiy a time relative to midday
 *
 *  @param timeoffset seconds after midday
 *
 *  @return LXGradientTime that can be resolved dynamically to sunrise
 */
+ (LXGradientTime *)middayTimeWithOffset:(NSTimeInterval)timeoffset;


/**
 *  Specifiy a time relative to sleeptime
 *
 *  @param timeoffset seconds after sleeptime
 *
 *  @return LXGradientTime that can be resolved dynamically to user's chosen sleeptime
 */
+ (LXGradientTime *)sleepTime;
+ (LXGradientTime *)sleepTimeWithOffset:(NSTimeInterval)offset;


/**
 *  Specifiy a time relative to wakeuptime
 *
 *  @param timeoffset seconds after wakeuptime
 *
 *  @return LXGradientTime that can be resolved dynamically to user's chosen wakeuptime
 */
+ (LXGradientTime *)wakeupTime;
+ (LXGradientTime *)wakeupTimeWithOffset:(NSTimeInterval)offset;

/**
 *  Specifiy a time relative to midnight
 *
 *  @param timeoffset seconds after midnight
 *
 *  @return LXGradientTime
 */
+ (LXGradientTime *)timeAfterMidnight:(NSTimeInterval)offset;

/**
 *  Create a time with a specific hour/minute
 *
 *  @param hour    hour (0-23)
 *  @param minutes minute (0-59)
 *
 *  @return LXGradientTime
 */
+ (LXGradientTime *)timeWithHour:(NSInteger)hour minutes:(NSInteger)minutes;


/**
 *  Calculated time since midnight (beginning of day)
 *
 *  @return seconds since midnight
 */
- (NSTimeInterval)timeIntervalSinceMidnight;

/**
 *  Calculated time since sunrise
 *
 *  @return seconds since sunrise
 */
- (NSTimeInterval)timeIntervalSinceSunrise;

/**
 *  Compares two LXGradientTimes.  Useful for sorting.
 *
 *  @param gradientTime other time to compare to
 *
 *  @return NSComparisonResults
 */
- (NSComparisonResult)compare:(LXGradientTime *)gradientTime;

@end
