//
//  NSDate+Extensions.h
//  donna
//
//  Created by Arshad Tayyeb on 3/7/12.
//  Copyright (c) 2012 Incredible Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEINTERVAL(hour, minute) (3600 * hour + 60 * minute)

@interface NSDate (Extensions)
- (NSString *)relativePastDateString;
+ (NSString *)relativeTimeLabelStringForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSString *)timeAndRelativeTimeLabelStringForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSString *)writtenOutDateStringWithDay:(BOOL)showDay showYear:(BOOL)showYear;
- (NSString *)relativeDateString;
- (NSString *)relativeFutureDateString;
- (NSString *)latenessStringFromDate:(NSDate *)tripStartTime withTripDuration:(NSTimeInterval)duration;
- (NSDate *)floor; // returns midnight (beginning) of date
- (NSDate *)ceil; //returns 23:59:59 of date
- (NSArray *)dateRangeForDay;
+ (SEL)comparisonSelectorForPredicateOperator:(NSPredicateOperatorType)operatorType;
+ (NSUInteger)operatorForComparisonSelector:(SEL)selector;
- (BOOL)isToday;
- (BOOL)isSameDayAsDate:(NSDate *)otherDate;
- (BOOL)isNotSameDayAsDate:(NSDate *)otherDate;
- (BOOL)isEarlierDayThanDate:(NSDate *)otherDate;
- (BOOL)isLaterDayThanDate:(NSDate *)otherDate;

- (BOOL)isInThePast;
- (BOOL)isInTheFuture;

+(NSDate*)dateFromRFC1123:(NSString*)value_;

+ (NSDate *)dateWithTimeIntervalSinceMidnight:(NSTimeInterval)seconds;

- (NSString *)shortFormat;
- (NSString *)mediumFormat;
- (NSString *)shortDateOnlyString;
- (NSString *)relativeShortDateOnlyString;  // Monday, October 4, etc.
- (NSString *)todayOrTomorrowStringWithSuffix:(NSString *)suffix; //Yesterday, Today, Tomorrow, or nil  (If suffix is provided, will append if there is a returned word.  (e.g., @" ", @", ")
- (NSString *)relativeWeekdayStringWithSuffix:(NSString *)suffix; //same as todayOrTomorrowStringWithSuffix, but for other days, returns the name of the weekday
- (NSString *)timeString;
- (NSString *)timeStringWithSeconds:(BOOL)showSeconds;
- (NSString *)timeRangeStringToTime:(NSDate *)endDate;
- (NSString *)timeRangeStringToTimeWithDay:(NSDate *)endDate;
- (NSString *)timeRangeWithDay:(NSDate *)endDate;
- (NSString *)hotDateString;    //returns an RFC1123 string
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)nextHalfHour;//rounds up to the next half hour from now
- (NSDate *)nextHour; //rounds up to the next hour from now

- (BOOL)isBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

@interface NSDate (Sql)
+ (id)dateWithSqlDateString:(NSString *)inString;
- (NSString *)sqlDateString;
@end

@interface NSDate (Iso8601)
+ (id)dateWithIso8601DateString:(NSString *)inString;
- (NSString *)iso8601DateString;
@end


