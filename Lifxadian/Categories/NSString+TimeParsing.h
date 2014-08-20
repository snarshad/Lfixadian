//
//  NSString+TimeParsing.h
//  donna
//
//  Created by Arshad Tayyeb on 1/23/12.
//  Copyright (c) 2012 Incredible Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEINTERVAL_ONE_MINUTE (60)
#define TIMEINTERVAL_FIVE_MINUTES (TIMEINTERVAL_ONE_MINUTE * 5)
#define TIMEINTERVAL_ONE_HOUR (TIMEINTERVAL_ONE_MINUTE * 60)
#define TIMEINTERVAL_ONE_DAY (TIMEINTERVAL_ONE_HOUR * 24)
#define TIMEINTERVAL_ONE_WEEK (TIMEINTERVAL_ONE_DAY * 7)
#define TIMEINTERVAL_ONE_MONTH (TIMEINTERVAL_ONE_DAY * 30)
#define TIMEINTERVAL_ONE_YEAR (TIMEINTERVAL_ONE_DAY * 365)

typedef enum eDurationUnit {
    kDurationUnitUnknown,
    kDurationUnitYears,
    kDurationUnitMonths,
    kDurationUnitWeeks,
    kDurationUnitDays,
    kDurationUnitHours,
    kDurationUnitMinutes,
    kDurationUnitSeconds,
    kDurationUnitMicroseconds,
    kDurationUnitMilliseconds
} eDurationUnit;

@interface NSString (TimeParsing)
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)seconds;
+ (NSString *)downRoundedStringFromTimeInterval:(NSTimeInterval)seconds; // like above, but rounds down to nearest .5 unit
+ (NSString *)shortStringFromTimeInterval:(NSTimeInterval)seconds;
+ (NSString *)shortStringFromTimeInterval:(NSTimeInterval)seconds alwaysShowUnit:(BOOL)alwaysShowUnit;
+ (NSString *)downRoundedShortStringFromTimeInterval:(NSTimeInterval)seconds;
+ (NSString *)downRoundedShortStringFromTimeInterval:(NSTimeInterval)seconds alwaysShowUnit:(BOOL)alwaysShowUnit;
+ (NSString *)shortStringFromTimeInterval:(NSTimeInterval)seconds showUnit:(BOOL)showUnit pluralize:(BOOL)pluralize showSpace:(BOOL)showSpace; // pluralize and showSpace are ignored if showUnit == NO
+ (NSString *)shortRoundedArrivalStringFromTimeInterval:(NSTimeInterval)seconds;
- (NSTimeInterval)timeInterval;

+ (NSString *)shortUnitStringForTimeInterval:(NSTimeInterval)number;
+ (NSString *)unitStringForTimeInterval:(NSTimeInterval)number;
+ (NSString *)unitAbbreviationStringForTimeInterval:(NSTimeInterval)number;

@end
