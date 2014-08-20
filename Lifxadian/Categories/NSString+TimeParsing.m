//
//  NSString+TimeParsing.m
//  donna
//
//  Created by Arshad Tayyeb on 1/23/12.
//  Copyright (c) 2012 Incredible Labs. All rights reserved.
//

#import "NSString+TimeParsing.h"

static NSMutableCharacterSet *g_skippedCharset = nil;

@interface NSString (TimeParsing_private)
+ (eDurationUnit)durationUnitFromString:(NSString *)stringQualifier;
@end
    
@implementation NSString (TimeParsing)


- (NSTimeInterval)timeInterval
{
    if (!g_skippedCharset)
    {
        g_skippedCharset = [[NSMutableCharacterSet alloc] init];
        [g_skippedCharset formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [g_skippedCharset formUnionWithCharacterSet:[NSCharacterSet controlCharacterSet]];
        [g_skippedCharset formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    }
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner setCharactersToBeSkipped:g_skippedCharset];
    
    NSTimeInterval time = 0.0;
    
	while (![scanner isAtEnd]) {
		NSString *numbers = nil;
        NSTimeInterval timeToAdd = 0;
		if ([scanner scanUpToCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&numbers]) {
			timeToAdd = [numbers floatValue];
            NSString *unitString = nil;
            [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&unitString];
            eDurationUnit unit = [NSString durationUnitFromString:unitString];
            
            switch (unit) {
                case kDurationUnitYears:
                    timeToAdd *= TIMEINTERVAL_ONE_YEAR;
                    break;
                case kDurationUnitMonths:
                    timeToAdd *= TIMEINTERVAL_ONE_MONTH;
                    break;
                    
                case kDurationUnitWeeks:
                    timeToAdd *= 7;
                case kDurationUnitDays:
                    timeToAdd *= 24;                    
                case kDurationUnitHours:
                    timeToAdd *= 60;
                case kDurationUnitMinutes:
                    timeToAdd *= 60;
                    break;
                    
                case kDurationUnitMilliseconds:
                    timeToAdd /= 1000;
                    break;
                case kDurationUnitMicroseconds:
                    timeToAdd /= 1000000;                    
                    break;
                    
                case kDurationUnitSeconds:
                default:
                    break;
            }
        }
        time += timeToAdd;
    }
    return time;
}

+ (NSString *)unitAbbreviationStringForTimeInterval:(NSTimeInterval)number
{
    NSString *abbr = nil;
    
    if (((long)number / TIMEINTERVAL_ONE_MINUTE) == 0)
    {
        abbr = NSLocalizedString(@"s", @"seconds abbr");
    } else if (((long)number / TIMEINTERVAL_ONE_HOUR) == 0) {
        abbr = NSLocalizedString(@"m", @"minutes abbr");
    } else if (((long)number / TIMEINTERVAL_ONE_DAY) == 0) {
        abbr = NSLocalizedString(@"h", @"hours abbr");
    } else if (((long)number / TIMEINTERVAL_ONE_MONTH) == 0) {
        abbr = NSLocalizedString(@"d", @"days abbr");
    } else if (((long)number / TIMEINTERVAL_ONE_YEAR) == 0) {
        abbr = NSLocalizedString(@"mo", @"months abbr");
    } else if (((long)number > TIMEINTERVAL_ONE_YEAR)) {
        abbr = NSLocalizedString(@"yr", @"years abbr");
    }
    return abbr;
}

+ (NSString *)shortRoundedArrivalStringFromTimeInterval:(NSTimeInterval)seconds {
    NSInteger minutesUntilArrival = (NSInteger)(seconds / TIMEINTERVAL_ONE_MINUTE);
    NSInteger roundedTravelTime = minutesUntilArrival < 10 ? minutesUntilArrival : ((NSInteger)(minutesUntilArrival + 2.5) / 5) * 5;
    return roundedTravelTime >= 2 ? [NSString stringWithFormat:@"~%@",[NSString shortStringFromTimeInterval:roundedTravelTime * TIMEINTERVAL_ONE_MINUTE showUnit:YES pluralize:YES showSpace:YES]] : NSLocalizedString(@"Nearby", nil);
}

+ (NSString *)shortUnitStringForTimeInterval:(NSTimeInterval)number
{
    NSString *str = nil;
    
    if (((long)number / TIMEINTERVAL_ONE_MINUTE) == 0)
    {
        str = NSLocalizedString(@"sec", @"seconds short");
    } else if (((long)number / TIMEINTERVAL_ONE_HOUR) == 0) {
        str = NSLocalizedString(@"min", @"minutes short");
    } else if (((long)number / 86400) == 0) {
        str = NSLocalizedString(@"hr", @"hours short");
    } else if (((long)number / (86400 * 30)) == 0) {
        str = NSLocalizedString(@"days", @"days short");
    } else if (((long)number / TIMEINTERVAL_ONE_YEAR) == 0) {
        str = NSLocalizedString(@"mon", @"months short");
    } else if (((long)number > TIMEINTERVAL_ONE_YEAR)) {
        str = NSLocalizedString(@"yrs", @"years short");
    }
    return str;
}

+ (NSString *)unitStringForTimeInterval:(NSTimeInterval)number
{
    NSString *str = nil;
    //TODO: handle singular vs plural
    
    if (((long)number / TIMEINTERVAL_ONE_MINUTE) == 0)
    {
        str = NSLocalizedString(@"seconds", @"seconds");
    } else if (((long)number / TIMEINTERVAL_ONE_HOUR) == 0) {
        str = NSLocalizedString(@"minutes", @"minutes str");
    } else if (((long)number / TIMEINTERVAL_ONE_DAY) == 0) {
        str = NSLocalizedString(@"hours", @"hours str");
    } else if (((long)number / TIMEINTERVAL_ONE_MONTH) == 0) {
        str = NSLocalizedString(@"days", @"days str");
    } else if (((long)number / TIMEINTERVAL_ONE_YEAR) == 0) {
        str = NSLocalizedString(@"months", @"months str");
    } else if (((long)number > TIMEINTERVAL_ONE_YEAR)) {
        str = NSLocalizedString(@"years", @"year str");
    }
    return str;
}

+ (NSString *)shortStringFromTimeInterval:(NSTimeInterval)seconds 
{
    return [NSString shortStringFromTimeInterval:seconds alwaysShowUnit:false];
}

+ (NSString *)shortStringFromTimeInterval:(NSTimeInterval)seconds showUnit:(BOOL)showUnit pluralize:(BOOL)pluralize showSpace:(BOOL)showSpace {
    NSString *singleUnit = showUnit ? [self shortUnitStringForTimeInterval:seconds] : @"";
    double  number = seconds;
    BOOL showFractions = NO;
    
    if (((long)number / TIMEINTERVAL_ONE_MINUTE) == 0)
    {
        //we are set - just seconds reported
    } else if (((long)number / TIMEINTERVAL_ONE_HOUR) == 0) {
        number /= TIMEINTERVAL_ONE_MINUTE;
    } else if (((long)number / TIMEINTERVAL_ONE_DAY) == 0) {
        number /= TIMEINTERVAL_ONE_HOUR;
        showFractions = YES;
    } else if (((long)number / TIMEINTERVAL_ONE_MONTH) == 0) {
        number /= TIMEINTERVAL_ONE_DAY;
        showFractions = YES;
    } else if (((long)number / TIMEINTERVAL_ONE_YEAR) == 0) {
        number /= (TIMEINTERVAL_ONE_MONTH);
        showFractions = YES;
    } else if (((long)number > TIMEINTERVAL_ONE_YEAR)) {
        number /= TIMEINTERVAL_ONE_YEAR;
        showFractions = YES;
    }
    // examples if showUnits and pluralize: 1.0hr, 1.1hrs, 0.2hrs, 1 min, 2 mins, 0 mins
    NSString *separator = showUnit && showSpace ? @" " : @"";
    NSString *s = showUnit && pluralize ? (showFractions ? (![[NSString stringWithFormat:@"%0.1f", number] isEqualToString:@"1.0"] ? @"s" : @"") : ((int)roundf(number) != 1 ? @"s" : @"")) : @"";
    if (showFractions)
    {
        return [NSString stringWithFormat:@"%0.1f%@%@%@", number, separator, singleUnit, s];
    } else {
        return [NSString stringWithFormat:@"%d%@%@%@", (int)roundf(number), separator, singleUnit, s];
    }

}

+ (NSString *)shortStringFromTimeInterval:(NSTimeInterval)seconds alwaysShowUnit:(BOOL)alwaysShowUnit
{
    return [self shortStringFromTimeInterval:seconds showUnit:alwaysShowUnit pluralize:NO showSpace:NO];
}

+ (NSString *)downRoundedStringFromTimeInterval:(NSTimeInterval)seconds
{
    NSString    *singleUnit = @"second";
    double  number = seconds;
    BOOL showFractions = NO;
    
    if (((long)number / 60) == 0)
    {
        //we are set - just seconds reported
    } else if (((long)number / 3600) == 0) {
        singleUnit = @"minute";
        number /= 60.0;
    } else if (((long)number / 86400) == 0) {
        singleUnit = @"hour";
        number /= 3600.0;
        showFractions = YES;
    } else if (((long)number / (86400 * 30)) == 0) {
        singleUnit = @"day";
        number /= 86400.0;
        showFractions = YES;
    } else if (((long)number / (86400 * 30 * 365)) == 0) {
        singleUnit = @"month";
        number /= (86400.0 * 30.0);
        showFractions = YES;
    } else if (((long)number > (86400 * 30 * 365))) {
        singleUnit = @"year";
        number /= (86400.0 * 30.0 * 365.0);
        showFractions = YES;
    }
    
    if (number >= 1.5 || number == 0)
    {
        singleUnit = [singleUnit stringByAppendingString:@"s"];
    }
    
    NSInteger fractionalPart = (long)(number * 10) % 10;
    
    NSString *fractionString = @"";
    if (fractionalPart >= 5) {
        fractionString = @".5";
    }
    
    
    if (showFractions)
    {
        return [NSString stringWithFormat:@"%ld%@ %@", (long)number, fractionString, singleUnit];
    } else {
        return [NSString stringWithFormat:@"%ld %@", (long)number, singleUnit];
    }
}

+ (NSString *)downRoundedShortStringFromTimeInterval:(NSTimeInterval)seconds
{
    return [self downRoundedShortStringFromTimeInterval:seconds alwaysShowUnit:NO];
}

+ (NSString *)downRoundedShortStringFromTimeInterval:(NSTimeInterval)seconds alwaysShowUnit:(BOOL)alwaysShowUnit
{
    NSString    *singleUnit = alwaysShowUnit ? [self shortUnitStringForTimeInterval:seconds] : @"";
    double  number = seconds;
    BOOL showFractions = NO;
    
    if (((long)number / TIMEINTERVAL_ONE_MINUTE) == 0)
    {
        //we are set - just seconds reported
    } else if (((long)number / TIMEINTERVAL_ONE_HOUR) == 0) {
        if(!alwaysShowUnit) singleUnit = @"";
        number /= TIMEINTERVAL_ONE_MINUTE;
    } else if (((long)number / TIMEINTERVAL_ONE_DAY) == 0) {
        number /= TIMEINTERVAL_ONE_HOUR;
        showFractions = YES;
    } else if (((long)number / TIMEINTERVAL_ONE_MONTH) == 0) {
        number /= TIMEINTERVAL_ONE_DAY;
        showFractions = YES;
    } else if (((long)number / TIMEINTERVAL_ONE_YEAR) == 0) {
        number /= (TIMEINTERVAL_ONE_MONTH);
        showFractions = YES;
    } else if (((long)number > TIMEINTERVAL_ONE_YEAR)) {
        number /= TIMEINTERVAL_ONE_YEAR;
        showFractions = YES;
    }
    
    NSInteger fractionalPart = (long)(number * 10) % 10;
    
    NSString *fractionString = @"";
    if (fractionalPart >= 5) {
        fractionString = @".5";
    }
    
    if (showFractions)
    {
        return [NSString stringWithFormat:@"%ld%@%@", (long)number, fractionString, singleUnit];
    } else {
        return [NSString stringWithFormat:@"%ld%@", (long)number, singleUnit];
    }
    
}


+ (NSString *)stringFromTimeInterval:(NSTimeInterval)seconds
{
    NSString    *singleUnit = @"second";
    double  number = seconds;
    BOOL showFractions = NO;
    
    if (((long)number / TIMEINTERVAL_ONE_MINUTE) == 0)
    {
        //we are set - just seconds reported
    } else if (((long)number / TIMEINTERVAL_ONE_HOUR) == 0) {
        singleUnit = @"minute";
        number /= TIMEINTERVAL_ONE_MINUTE;
    } else if (((long)number / TIMEINTERVAL_ONE_DAY) == 0) {
        singleUnit = @"hour";
        number /= TIMEINTERVAL_ONE_HOUR;
        showFractions = YES;
    } else if (((long)number / TIMEINTERVAL_ONE_MONTH) == 0) {
        singleUnit = @"day";
        number /= TIMEINTERVAL_ONE_DAY;
        showFractions = YES;
    } else if (((long)number / TIMEINTERVAL_ONE_YEAR) == 0) {
        singleUnit = @"month";
        number /= (TIMEINTERVAL_ONE_MONTH);
        showFractions = YES;
    } else if (((long)number > TIMEINTERVAL_ONE_YEAR)) {
        singleUnit = @"year";
        number /= TIMEINTERVAL_ONE_YEAR;
        showFractions = YES;
    }
    
    if (number >= 1.1)
    {
        singleUnit = [singleUnit stringByAppendingString:@"s"];
    }
    
    NSInteger fractionalPart = (long)(number * 10) % 10;

    NSString *fractionString = @"";
    if (fractionalPart >= 1) {
        fractionString = [NSString stringWithFormat:@".%ld", (long)fractionalPart];
    }
    
    if (showFractions)
    {
        return [NSString stringWithFormat:@"%ld%@ %@", (long)number, fractionString, singleUnit];
    } else {
        return [NSString stringWithFormat:@"%ld %@", (long)number, singleUnit];
    }
}


+ (eDurationUnit)durationUnitFromString:(NSString *)stringQualifier {

	if (stringQualifier.length == 0)
    {
        return kDurationUnitUnknown;
    }
    
    char firstCharacter = [[stringQualifier lowercaseString] characterAtIndex:0];
    char secondCharacter = 0;
    if (stringQualifier.length > 1)
        secondCharacter = [[stringQualifier lowercaseString] characterAtIndex:1];
        
	eDurationUnit unit = kDurationUnitUnknown;

    //y, m(o), w, d, h, m(i), s, m(s), us
    
    switch (firstCharacter)
    {
        case 'y':
            unit = kDurationUnitYears;
            break;
        case 'w':
            unit = kDurationUnitWeeks;
            break;
        case 'd':
            unit = kDurationUnitDays;
            break;
        case 'h':
            unit = kDurationUnitHours;
            break;
        case 's':
            unit = kDurationUnitSeconds;
            break;
        case 'u':
            unit = kDurationUnitYears;
            break;
        case 'm':
            //check for mo (months) or ms (milliseconds)
            switch (secondCharacter) {
                case 'o':
                    unit = kDurationUnitMonths;
                    break;
                case 's':
                    unit = kDurationUnitMilliseconds;
                    break;
                default:
                    unit = kDurationUnitMinutes;
                    break;
            }
            break;

        default:
            break;    
    }
        
	return unit;
}
@end
