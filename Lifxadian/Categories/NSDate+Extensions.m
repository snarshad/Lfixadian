//
//  NSDate+Extensions.m
//  donna
//
//  Created by Arshad Tayyeb on 3/7/12.
//  Copyright (c) 2012 Incredible Labs. All rights reserved.
//

#import "NSString+TimeParsing.h"

static NSCalendar *g_gregorian = nil;
static NSDateFormatter *g_shortDateWithSecondsFormatter = nil;
static NSDateFormatter *g_shortDateFormatter = nil;
static NSDateFormatter *g_relativeShortDateFormatter = nil;
static NSDateFormatter *g_shortDateOnlyFormatter = nil;
static NSDateFormatter *g_timeOnlyFormat = nil;
static NSDateFormatter *g_timeOnlyFormatWithSeconds = nil;
static NSDateFormatter *g_dayOnlyFormat = nil;


@interface NSDate (Extensions_private)
- (NSString *)relativePastDateString;
+ (NSString *)relativeTimeLabelStringForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSString *)relativeFutureDateString;
- (NSCalendar *)gregorianCalendar;
@end


@implementation NSDate (Extensions)

- (NSInteger)dayofYear
{
    
    NSUInteger dayOfYear =
    [[[self class] gregorianCalendar] ordinalityOfUnit:NSDayCalendarUnit
                         inUnit:NSYearCalendarUnit forDate:self];
    return dayOfYear;
}

- (NSString *)relativeShortDateOnlyString
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_relativeShortDateFormatter = [[NSDateFormatter alloc] init];
        g_relativeShortDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEdMMMM" options:0
                                         locale:[NSLocale currentLocale]];
    });

    @synchronized(g_relativeShortDateFormatter)
    {
        return [NSString stringWithFormat:@"%@", [g_relativeShortDateFormatter stringFromDate:self]];
    }
}

- (NSString *)relativeWeekdayStringWithSuffix:(NSString *)suffix
{
    NSString *returnString = [self todayOrTomorrowStringWithSuffix:suffix];
    if (returnString.length)
    {
        return returnString;
    }
    
    //if it wasn't today, tomorrow, or yesterday, get the day
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_dayOnlyFormat = [[NSDateFormatter alloc] init];
        g_dayOnlyFormat.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0
                                                                                   locale:[NSLocale currentLocale]];
    });

    returnString = [g_dayOnlyFormat stringFromDate:self];
    
    if (suffix.length)
    {
        returnString = [returnString stringByAppendingString:suffix];
    }
    
    return returnString ? returnString : @"";
}

- (NSString *)todayOrTomorrowStringWithSuffix:(NSString *)suffix
{
    NSString *returnString = nil;
    
    NSTimeInterval interval = [self timeIntervalSinceDate:[[NSDate date] floor]];
    
    if (interval > TIMEINTERVAL_ONE_DAY * 2)
        return @"";
    
    NSInteger meInDaysOfThisYear = [self dayofYear];
    NSInteger startOfTodayInDaysOfThisYear = [[[NSDate date] floor] dayofYear];
    
    if (startOfTodayInDaysOfThisYear == meInDaysOfThisYear)
    {
        returnString = NSLocalizedString(@"Today", nil);
    } else if (((meInDaysOfThisYear - startOfTodayInDaysOfThisYear) == 1) ||
               (meInDaysOfThisYear == 0 && startOfTodayInDaysOfThisYear > 364)) /* new year's */
    {
                   returnString = NSLocalizedString(@"Tomorrow", nil);
    } else if (((meInDaysOfThisYear - startOfTodayInDaysOfThisYear) == -1)  ||
               ((startOfTodayInDaysOfThisYear == 0 && meInDaysOfThisYear) > 364)) /* new year's */
    {
                   returnString = NSLocalizedString(@"Yesterday", nil);
    }
                           
    if (suffix.length)
    {
        returnString = [returnString stringByAppendingString:suffix];
    }

    return returnString ? returnString : @"";
}

- (NSString *)shortDateOnlyString
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shortDateOnlyFormatter = [[NSDateFormatter alloc] init];
        [g_shortDateOnlyFormatter setDateStyle:NSDateFormatterMediumStyle];
        [g_shortDateOnlyFormatter setTimeStyle:NSDateFormatterNoStyle];
    });

    @synchronized(g_shortDateOnlyFormatter)
    {
        return [NSString stringWithFormat:@"%@", [g_shortDateOnlyFormatter stringFromDate:self]];
    }
}

- (NSString *)timeStringWithSeconds:(BOOL)showSeconds
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_timeOnlyFormat = [[NSDateFormatter alloc] init];
        [g_timeOnlyFormat setDateFormat:@"h:mma"];
        g_timeOnlyFormatWithSeconds = [[NSDateFormatter alloc] init];
        [g_timeOnlyFormatWithSeconds setDateFormat:@"h:mm:ssa"];
        
    });
    
    if (showSeconds) {
        @synchronized (g_timeOnlyFormatWithSeconds)
        {
            return [g_timeOnlyFormatWithSeconds stringFromDate:self];
        }
    } else {
        @synchronized (g_timeOnlyFormat)
        {
            return [g_timeOnlyFormat stringFromDate:self];
        }
    }
}


- (NSString *)timeString
{
    return [self timeStringWithSeconds:NO];
}

- (NSString *)timeRangeStringToTime:(NSDate *)endDate
{
    return [[self timeString] stringByAppendingFormat:@" - %@", [endDate timeString]];
}

- (NSString *)timeRangeStringToTimeWithDay:(NSDate *)endDate
{
    if ([endDate timeIntervalSinceDate:[[NSDate date] floor]] > TIMEINTERVAL_ONE_DAY &&
        [endDate timeIntervalSinceDate:[self floor]] > TIMEINTERVAL_ONE_DAY)
    {
        return [[self timeString] stringByAppendingFormat:@" - %@%@", [endDate relativeWeekdayStringWithSuffix:@", "], [endDate timeString]];
    } else {
        return [[self timeString] stringByAppendingFormat:@" - %@", [endDate timeString]];
    }
}

// Creates a string of 00:00 - 00:00. Includes date/day when it makes sense to.
- (NSString *)timeRangeWithDay:(NSDate *)endDate
{
    if (endDate) {
        if ([self timeIntervalSinceDate:[[NSDate date] floor]] < TIMEINTERVAL_ONE_DAY) {
            return [NSString stringWithFormat:@"%@", [self timeRangeStringToTimeWithDay:endDate]];
        } else {
            return [NSString stringWithFormat:@"%@%@", [self relativeWeekdayStringWithSuffix:@", "], [self timeRangeStringToTimeWithDay:endDate]];
        }
    } else {
        if ([self timeIntervalSinceDate:[[NSDate date] floor]] < TIMEINTERVAL_ONE_DAY) {
            return [NSString stringWithFormat:@"%@", [self timeString]];
        } else {
            return [NSString stringWithFormat:@"%@%@", [self relativeWeekdayStringWithSuffix:@", "], [self timeString]];
        }
    }
}


- (NSString *)mediumFormat
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shortDateWithSecondsFormatter = [[NSDateFormatter alloc] init];
        [g_shortDateWithSecondsFormatter setDateStyle:NSDateFormatterMediumStyle];
        [g_shortDateWithSecondsFormatter setTimeStyle:NSDateFormatterMediumStyle];
    });
    
    @synchronized (g_shortDateWithSecondsFormatter)
    {
        return [NSString stringWithFormat:@"%@", [g_shortDateWithSecondsFormatter stringFromDate:self]];
    }
}

- (NSString *)shortFormat
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shortDateFormatter = [[NSDateFormatter alloc] init];
        [g_shortDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [g_shortDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    });

    @synchronized (g_shortDateFormatter)
    {
        return [NSString stringWithFormat:@"%@", [g_shortDateFormatter stringFromDate:self]];
    }
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:self options:0];
}

- (NSString *)relativePastDateString
{
    NSString *dateStr = nil;
    
    NSTimeInterval interval = [self timeIntervalSinceNow] * -1.0;
    
    if( interval < ((NSTimeInterval)(2.5)) ) {
        dateStr = NSLocalizedString(@"now", nil);
    } else if( interval <= ((NSTimeInterval)(15)) ) {
        dateStr = [NSString stringWithFormat:NSLocalizedString(@"%ld secs ago", nil), (long)interval];
    } else if( interval <= ((NSTimeInterval)(60)) ) {
        dateStr = [NSString stringWithFormat:NSLocalizedString(@"%ld secs ago", nil), (long)interval - ((long)interval % 5)];
    } else if( interval < TIMEINTERVAL_ONE_HOUR * 1.5 ) // if less than 1 and a half hours
    {
        NSInteger mins = (NSInteger)(interval / (NSTimeInterval)60.0);
        dateStr = [NSString stringWithFormat:NSLocalizedString(@"%d min ago", nil), mins];
    }
    else if( interval < ((NSTimeInterval)(TIMEINTERVAL_ONE_DAY)) ) // if less than one day
    {
        NSInteger hours = (NSInteger)(interval / TIMEINTERVAL_ONE_HOUR);
        NSInteger minutes = (NSInteger)((NSInteger)interval % TIMEINTERVAL_ONE_HOUR)/TIMEINTERVAL_ONE_MINUTE;
        
        if( hours == 1 && minutes < 5)
            dateStr = NSLocalizedString(@"1 hour ago", nil);
        else
        {
            if (minutes > 5) {
                int minutesFraction = (int)((minutes * 10)/60);
                dateStr = [NSString stringWithFormat:NSLocalizedString(@"%d.%d hours ago", nil), hours, minutesFraction];
            } else {
                dateStr = [NSString stringWithFormat:NSLocalizedString(@"%d hours ago", nil), hours];
            }
        }
    }
    else if( interval < (TIMEINTERVAL_ONE_DAY * 6) ) // if less than six days
    {
        NSInteger days = (NSInteger)(interval / TIMEINTERVAL_ONE_DAY);
        
        if( days == 1 )
            dateStr = NSLocalizedString(@"1 day ago", nil);
        else
            dateStr = [NSString stringWithFormat:NSLocalizedString(@"%d days ago", nil), days];
    }
    else // if six days or more
    {
        static NSDateFormatter *g_reallyShortDateFormat = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            g_reallyShortDateFormat = [[NSDateFormatter alloc] init];
            [g_reallyShortDateFormat setDateFormat:@"MMM d"];
        });
        
        @synchronized(g_reallyShortDateFormat)
        {
            dateStr = [g_reallyShortDateFormat stringFromDate:self];
        }
    }
    
    return dateStr;
}

- (NSString *)relativeFutureDateString
{
    NSTimeInterval timeTillEvent = 0;
    NSString *theString;
    timeTillEvent = [self timeIntervalSinceNow];
    
    NSDate *todayCeiling = [[NSDate date] ceil];
    NSTimeInterval timeTillEventFromEndOfToday = [self timeIntervalSinceDate:todayCeiling];
    
    if (timeTillEventFromEndOfToday > TIMEINTERVAL_ONE_DAY) {
        static NSDateFormatter *g_futureDayDateFormat = nil;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            g_futureDayDateFormat = [[NSDateFormatter alloc] init];
            [g_futureDayDateFormat setDateStyle:NSDateFormatterMediumStyle];
            [g_futureDayDateFormat setTimeStyle:NSDateFormatterShortStyle];
        });
        
        theString = [NSString stringWithFormat:NSLocalizedString(@"in %d days", nil),  (int)(timeTillEventFromEndOfToday/TIMEINTERVAL_ONE_DAY) + 1];
    } else if (timeTillEventFromEndOfToday > 0 && timeTillEventFromEndOfToday <= TIMEINTERVAL_ONE_DAY) {
        theString = NSLocalizedString(@"Tomorrow", nil);
    } else if (timeTillEvent > (TIMEINTERVAL_ONE_HOUR*4)) {
        theString = [NSString stringWithFormat:NSLocalizedString(@"in %d hour%@", nil), (int)(timeTillEvent/(TIMEINTERVAL_ONE_HOUR)), (int)(timeTillEvent/(TIMEINTERVAL_ONE_HOUR)) > 1 ? @"s" : @""];
    } else if (timeTillEvent > TIMEINTERVAL_ONE_HOUR) {
        // round up to .5s
        float tf = (timeTillEvent/(TIMEINTERVAL_ONE_HOUR));
        NSString *suffix = ((((int)(tf * 10)) % 10) > 4) ? @".5" : @"";
                 
        theString = [NSString stringWithFormat:NSLocalizedString(@"in %d%@ hour%@", nil), (int)tf, suffix, (tf == 1 && suffix.length == 0) ? @"" : @"s"];
    } else if (timeTillEvent > TIMEINTERVAL_ONE_MINUTE) {
        theString = [NSString stringWithFormat:NSLocalizedString(@"in %d minute%@", nil), (int)(timeTillEvent/TIMEINTERVAL_ONE_MINUTE), timeTillEvent/TIMEINTERVAL_ONE_MINUTE > 1 ? @"s" : @""];
    } else {
        theString = [self shortFormat];
    }    
    return theString;
}


- (NSString *)relativeDateString
{
    return [NSDate relativeTimeLabelStringForStartDate:self endDate:nil];
}


- (NSString *)writtenOutDateStringWithDay:(BOOL)showDay showYear:(BOOL)showYear
{
    static NSDateFormatter *g_writtenOutDateFormatter = nil;
    static NSDateFormatter *g_writtenOutDateFormatterWithoutYear = nil;
    static NSDateFormatter *g_writtenOutDateFormatterWithDay = nil;
    static NSDateFormatter *g_writtenOutDateFormatterWithDayWithoutYear = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //no day, with year
        g_writtenOutDateFormatter = [[NSDateFormatter alloc] init];
        g_writtenOutDateFormatter.dateStyle = NSDateFormatterLongStyle;
        g_writtenOutDateFormatter.timeStyle = NSDateFormatterNoStyle;
        
        //no day, no year
        g_writtenOutDateFormatterWithoutYear = [[NSDateFormatter alloc] init];
        g_writtenOutDateFormatterWithoutYear.dateFormat = @"MMMM d";

        //day, year
        g_writtenOutDateFormatterWithDay = [[NSDateFormatter alloc] init];
        [g_writtenOutDateFormatterWithDay setDateFormat:@"EEEE MMMM d, YYYY"];

        //day, no year
        g_writtenOutDateFormatterWithDayWithoutYear = [[NSDateFormatter alloc] init];
        [g_writtenOutDateFormatterWithDayWithoutYear setDateFormat:@"EEEE MMMM d"];
    });

    NSDateFormatter *formatter = nil;
    
    if (showDay)
    {
        formatter = showYear ? g_writtenOutDateFormatterWithDay : g_writtenOutDateFormatterWithDayWithoutYear;
    } else {
        formatter = showYear ? g_writtenOutDateFormatter : g_writtenOutDateFormatterWithoutYear;
    }
    return [formatter stringFromDate:self];
}

+ (NSString *)relativeTimeLabelStringForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
//    BOOL hasTime = NO;
//    BOOL isImminent = NO;
    NSTimeInterval timeTillEvent = 0.0;
    BOOL isInThePast = NO;
    BOOL isCurrent = NO;
    NSString *theString = @"";
    
    timeTillEvent = [startDate timeIntervalSinceNow];
    isInThePast = (timeTillEvent < 0);
     
    if (startDate && endDate)
    {
        NSTimeInterval timeTillEventEnd = [endDate timeIntervalSinceNow];
        isInThePast = (timeTillEvent < 0 && timeTillEventEnd < 0);

//        hasTime = YES;
        timeTillEvent = [startDate timeIntervalSinceNow];
        
        isCurrent = (timeTillEvent <= 0 && timeTillEventEnd > 0); 
//        isImminent = timeTillEvent > 0 && timeTillEvent < 60*60;

        if (isCurrent)
        {
            return NSLocalizedString(@"now", nil);
        } else if (isInThePast)
        {
            return [startDate relativePastDateString];
        } else {
            return [startDate relativeFutureDateString];
        }
    } else if (startDate) {
        if (isInThePast)
            return [startDate relativePastDateString];
        else 
            return [startDate relativeFutureDateString];
            
    }
    return theString;
}


+ (NSString *)timeAndRelativeTimeLabelStringForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
//    BOOL hasTime = NO;
//    BOOL isImminent = NO;
    NSTimeInterval timeTillEvent = 0.0;
    BOOL isInThePast = NO;
    BOOL isInTheRecentPast = NO;
    BOOL isCurrent = NO;
    NSString *theString = [startDate shortDateOnlyString];
    
    timeTillEvent = [startDate timeIntervalSinceNow];
    isInThePast = (timeTillEvent < 0);
    
    isInTheRecentPast = isInThePast && (timeTillEvent < - 4 * 60 * 60);
    
    if (!endDate)
    {
        // if it only has a startDate, consider it "now" if it's within 10 minutes
        isCurrent = isInThePast && (timeTillEvent > -(10 * 60));
    }
    
    if (startDate && endDate)
    {
        NSTimeInterval timeTillEventEnd = [endDate timeIntervalSinceNow];
        isInThePast = (timeTillEvent < 0 && timeTillEventEnd < 0);
        
//        hasTime = YES;

        isCurrent = (timeTillEvent <= 0 && timeTillEventEnd > 0); 
//        isImminent = timeTillEvent > 0 && timeTillEvent < 60*60;

    }
    
    NSString *postFix = isCurrent ? @"now" : 
    isInTheRecentPast ? [startDate relativePastDateString] : 
    !isInThePast ? [startDate relativeFutureDateString] : nil;
    
    if (postFix.length > 0)
    {
        theString = [theString stringByAppendingFormat:@" (%@)", postFix];
    }
    
    return theString;
}

- (NSString *)latenessStringFromDate:(NSDate *)tripStartTime withTripDuration:(NSTimeInterval)duration
{
    NSString *latenessString;
    {
        NSDate *arrivalDate = [tripStartTime dateByAddingTimeInterval:duration];
        NSTimeInterval late = [arrivalDate timeIntervalSinceDate:self];
        
        if (late < 0)
        {
            latenessString = [NSString stringWithFormat:NSLocalizedString(@"%@ early", nil), [NSString stringFromTimeInterval:-late]];
        } else if (late > 60.0 * 4.5) {
            latenessString = [NSString stringWithFormat:NSLocalizedString(@"%@ late", nil), [NSString stringFromTimeInterval:late]];
        } else {
            latenessString = [NSString stringWithFormat:NSLocalizedString(@"On Time", nil)];
        }
    }
    return latenessString;
}

// returns midnight (beginning) of date

+ (NSCalendar *)gregorianCalendar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [g_gregorian setTimeZone:[NSTimeZone localTimeZone]];

    });
    return g_gregorian;
}

- (NSDate *)floor
{
	
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = nil;
    @synchronized (g_gregorian)
    {
        components = [[[self class] gregorianCalendar] components:unitFlags fromDate:self];
    }
	components.hour = 0;
	components.minute = 0;
	
	NSDate *midnight = nil;
    @synchronized (g_gregorian)
    {
        midnight = [[[self class] gregorianCalendar] dateFromComponents:components];
    }
	
	return midnight;
}

//returns 23:59:59 of date
- (NSDate *)ceil
{
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = nil;
    @synchronized (g_gregorian)
    {
        components = [[[self class] gregorianCalendar] components:unitFlags fromDate:self];
    }
	components.hour = 23;
	components.minute = 59;
	components.second = 59;
	
    NSDate *dayEnd = nil;
    @synchronized (g_gregorian)
    {
        dayEnd = [[[self class] gregorianCalendar] dateFromComponents:components];
    }
	
	return dayEnd;	
}

- (NSArray *)dateRangeForDay
{
	return [NSArray arrayWithObjects:[self floor], [self ceil], nil];
}

+ (SEL)comparisonSelectorForPredicateOperator:(NSPredicateOperatorType)operatorType
{
	switch (operatorType)
	{
		case NSLessThanPredicateOperatorType:
		case NSLessThanOrEqualToPredicateOperatorType:  //technically, these should be off by one, but in practice, we'll only mean NSLessThanPredicateOperatorType
			return @selector(isEarlierDayThanDate:);
			break;
		case NSGreaterThanPredicateOperatorType:
		case NSGreaterThanOrEqualToPredicateOperatorType:
			return @selector(isLaterDayThanDate:);
			break;
		case NSNotEqualToPredicateOperatorType:
			return @selector(isNotSameDayAsDate:);
			break;
            
		case NSEqualToPredicateOperatorType:
		default:
			return @selector(isSameDayAsDate:);
			break;
	}
}

+ (NSUInteger)operatorForComparisonSelector:(SEL)selector
{
	if (selector == @selector(isEarlierDayThanDate:))
	{
		return NSLessThanPredicateOperatorType;
	}
	if (selector == @selector(isLaterDayThanDate:))
	{
		return NSGreaterThanPredicateOperatorType;
	}
	if (selector == @selector(isNotSameDayAsDate:))
	{
		return NSNotEqualToPredicateOperatorType;
	}
	if (selector == @selector(isSameDayAsDate:))
	{
		return NSEqualToPredicateOperatorType;
	}
	return NSCustomSelectorPredicateOperatorType; // Unknown, shouldn't get here!
}

- (BOOL)isNotSameDayAsDate:(NSDate *)otherDate
{
	return (![[self floor] isEqualToDate:[otherDate floor]]);		
}

- (BOOL)isToday {
    return [self isSameDayAsDate:[NSDate date]];
}

//To avoid time-zone confusion, we'll do a second check if we are within a 24 hr period
- (BOOL)isSameDayAsDate:(NSDate *)otherDate
{
	return (([[self floor] isEqualToDate:[otherDate floor]]) ||
			(abs([self timeIntervalSinceDate:otherDate]) < 86400));
}

- (BOOL)isEarlierDayThanDate:(NSDate *)otherDate
{
	return ([[self floor] compare:[otherDate floor]] == NSOrderedAscending);		
}

- (BOOL)isLaterDayThanDate:(NSDate *)otherDate
{
	return ([[self ceil] compare:[otherDate ceil]] == NSOrderedDescending);		
}

#pragma mark -

- (BOOL)isInThePast
{
    return [[NSDate date] earlierDate:self] == self;
}

- (BOOL)isInTheFuture
{
    return [[NSDate date] laterDate:self] == self;
}

#pragma mark -
//From: http://pastebin.com/UDpyr2Zi
+(NSDate*)dateFromRFC1123:(NSString*)value_
{
    if(value_ == nil)
        return nil;
    static NSDateFormatter *rfc1123 = nil;

    static dispatch_once_t onceTokenB;
    dispatch_once(&onceTokenB, ^{
        rfc1123 = [[NSDateFormatter alloc] init];
        rfc1123.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    });

    NSDate *ret = nil;
    @synchronized (rfc1123)
    {
        ret = [rfc1123 dateFromString:value_];
    }
    if(ret != nil)
        return ret;
    
    static NSDateFormatter *rfc850 = nil;
    

    static dispatch_once_t onceTokenA;
    dispatch_once(&onceTokenA, ^{
        rfc850 = [[NSDateFormatter alloc] init];
        rfc850.locale = rfc1123.locale;
        rfc850.timeZone = rfc1123.timeZone;
        rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    });
    
    @synchronized (rfc1123)
    {
        ret = [rfc850 dateFromString:value_];
    }

    if(ret != nil)
        return ret;
    
    static NSDateFormatter *asctime = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asctime = [[NSDateFormatter alloc] init];
        asctime.locale = rfc1123.locale;
        asctime.timeZone = rfc1123.timeZone;
        asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    });
    
    @synchronized (asctime)
    {
        return [asctime dateFromString:value_];
    }
}

//creates an rfc 1123 string
-(NSString*)hotDateString
{
    static NSDateFormatter *df = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
        df = formatter;
    });

    NSString *res = nil;
    @synchronized(df)
    {
        res = [df stringFromDate:self];
    }
    return res;
}

- (NSDate *)nextHalfHour {
    NSTimeInterval secsSinceBeginningOfDay = [self timeIntervalSinceDate:[self floor]];
    NSTimeInterval nextHalfHour = secsSinceBeginningOfDay - ((long)secsSinceBeginningOfDay % (long)(TIMEINTERVAL_ONE_HOUR/2)) + (TIMEINTERVAL_ONE_HOUR/2);
    return [[self floor] dateByAddingTimeInterval:nextHalfHour];
}

- (NSDate *)nextHour {
    NSTimeInterval secsSinceBeginningOfDay = [self timeIntervalSinceDate:[self floor]];
    NSTimeInterval nextHour = secsSinceBeginningOfDay - ((long)secsSinceBeginningOfDay % (long)TIMEINTERVAL_ONE_HOUR) + TIMEINTERVAL_ONE_HOUR;
    return [[self floor] dateByAddingTimeInterval:nextHour];
}

- (BOOL)isBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate; {
    if ([self isEqualToDate:startDate] || [self isEqualToDate:endDate]) {
        return YES;
    }
    
    if ([startDate earlierDate:self] == startDate && [endDate earlierDate:self] == self) {
        return YES;
    }
    return NO;
}

+ (NSDate *)dateWithTimeIntervalSinceMidnight:(NSTimeInterval)seconds {
    
    return [[[NSDate date] floor] dateByAddingTimeInterval:seconds];
    
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents *components = nil;
//    @synchronized ([[self class] gregorianCalendar])
//    {
//        components = [[[self class] gregorianCalendar] components:unitFlags fromDate:[NSDate date]];
//    }
//    components.hour = seconds / 3600.0;
//    components.minute = (seconds / 60.0) - (components.hour * 3600) ;
//    
//    NSDate *date = nil;
//    @synchronized ([[self class] gregorianCalendar])
//    {
//        date = [[[self class] gregorianCalendar] dateFromComponents:components];
//    }
//    
//    return date;
}


@end
