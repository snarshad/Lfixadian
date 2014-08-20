//
//  LXGradientTime.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientTime.h"
#import "EDSunriseSet.h"
#import "NSDate+Extensions.h"
#import "LXWakeupAndSleepTimes.h"

static NSString* const kTypeKey = @"type";
static NSString* const kOffsetKey = @"offset";

typedef enum eDynamicGradientTimeType {
    kGradientTimeTypeStatic = 0, /* for static times like 10am */
    kGradientTimeTypeSunrise, /* different dependent on day and location */
    kGradientTimeTypeSunset,  /* different dependent on day and location */
    kGradientTimeTypeMidday,  /* different dependent on day and location */

    kGradientTimeTypeWakeupTime,  /* different dependent on user setting */
    kGradientTimeTypeSleepTime,  /* different dependent on user setting */
} eDynamicGradientTimeType;


@interface LXGradientTime()
@property (readwrite) eDynamicGradientTimeType timeType;
@property (readwrite) NSTimeInterval offset;
@end

@implementation LXGradientTime

+ (NSArray *)typeCodeStrings {
    static NSArray *s_typeCodeStrings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_typeCodeStrings = @[@"time",
                              @"sunrise", @"sunset",
                              @"midday",
                              @"wakeup", @"sleep"
                              ];
    });
    return s_typeCodeStrings;
}

- (BOOL)isEqual:(LXGradientTime *)object {
    return (object.timeType == self.timeType && object.offset == self.offset);
}

- (NSString *)typeCodeString {
    return [[self class] typeCodeStrings][_timeType];
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@" %@ : %ld %@", [self typeCodeString], (long)_offset, [[NSDate dateWithTimeIntervalSinceMidnight:[self timeIntervalSinceMidnight]] timeString]] ;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[[self class] typeCodeStrings][self.timeType] forKey:kTypeKey];
    [coder encodeObject:@(self.offset) forKey:kOffsetKey];
}

- (NSDictionary *)dictionaryRepresentation {
    return @{kTypeKey : [[self class] typeCodeStrings][_timeType],
             kOffsetKey : @(_offset)};
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        NSString *typeString = dictionary[kTypeKey];
        _timeType = [[[self class] typeCodeStrings] indexOfObject:typeString];
        if ((int)_timeType < 0) {
            _timeType = kGradientTimeTypeStatic;
        }

        _offset = [dictionary[kOffsetKey] doubleValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        NSString *typeString = [coder decodeObjectForKey:kTypeKey];
        
        _timeType = [[[self class] typeCodeStrings] indexOfObject:typeString];
        
        if ((int)_timeType < 0) {
            _timeType = kGradientTimeTypeStatic;
        }
        
        _offset = (NSTimeInterval)[[coder decodeObjectForKey:kOffsetKey] doubleValue];
    }
    return self;
}

- (instancetype)initWithType:(eDynamicGradientTimeType)type offset:(NSTimeInterval)offset {
    if (self = [super init]) {
        self.timeType = type;
        self.offset = offset;
    }
    return self;
}

- (instancetype)initWithHour:(NSInteger)hour minute:(NSInteger)minute {
    if (hour < 0 || minute < 0 || hour > 23 || minute > 59) {
        NSLog(@"Error - invalid hour (%d) or minute (%d) specified", hour, minute);
        return nil;
    }
    
    if (self = [super init]) {
        self.timeType = kGradientTimeTypeStatic;
        self.offset = TIMEINTERVAL(hour, minute);
    }
    return self;
}



+ (LXGradientTime *)sunriseTime {
    return [[self alloc] initWithType:kGradientTimeTypeSunrise offset:0];
}

+ (LXGradientTime *)sunsetTime {
    return [[self alloc] initWithType:kGradientTimeTypeSunset offset:0];
}

+ (LXGradientTime *)middayTime {
    return [[self alloc] initWithType:kGradientTimeTypeMidday offset:0];
}

+ (LXGradientTime *)sunriseTimeWithOffset:(NSTimeInterval)timeoffset {
    return [[self alloc] initWithType:kGradientTimeTypeSunrise offset:timeoffset];
}

+ (LXGradientTime *)sunsetTimeWithOffset:(NSTimeInterval)timeoffset {
    return [[self alloc] initWithType:kGradientTimeTypeSunset offset:timeoffset];
}

+ (LXGradientTime *)middayTimeWithOffset:(NSTimeInterval)timeoffset {
    return [[self alloc] initWithType:kGradientTimeTypeMidday offset:timeoffset];
}

+ (LXGradientTime *)sleepTime {
    return [[self alloc] initWithType:kGradientTimeTypeSleepTime offset:0];
}

+ (LXGradientTime *)sleepTimeWithOffset:(NSTimeInterval)offset {
    return [[self alloc] initWithType:kGradientTimeTypeSleepTime offset:offset];
}

+ (LXGradientTime *)wakeupTime {
    return [[self alloc] initWithType:kGradientTimeTypeWakeupTime offset:0];
}

+ (LXGradientTime *)wakeupTimeWithOffset:(NSTimeInterval)offset {
    return [[self alloc] initWithType:kGradientTimeTypeWakeupTime offset:offset];
}

+ (LXGradientTime *)timeAfterMidnight:(NSTimeInterval)offset {
    return [[self alloc] initWithType:kGradientTimeTypeStatic offset:offset];
}

+ (LXGradientTime *)timeWithHour:(NSInteger)hour minutes:(NSInteger)minutes {
    return [[self alloc] initWithHour:hour minute:minutes];
}


- (NSTimeInterval)timeIntervalSinceMidnight {
    NSTimeInterval baseTime = 0; /* start with midnight, adjust as necessary */
    
    switch (self.timeType) {
        case kGradientTimeTypeSunrise:
            baseTime = [EDSunriseSet sharedManager].sunriseSeconds;
            break;
        case kGradientTimeTypeSunset:
            baseTime = [EDSunriseSet sharedManager].sunsetSeconds;
            break;
        case kGradientTimeTypeMidday:
            baseTime = [EDSunriseSet sharedManager].sunriseSeconds + ([EDSunriseSet sharedManager].sunsetSeconds - [EDSunriseSet sharedManager].sunriseSeconds)/2.0;
            break;
        case kGradientTimeTypeWakeupTime:
            baseTime = [LXWakeupAndSleepTimes sharedInstance].wakeTime;
            break;
        case kGradientTimeTypeSleepTime:
            baseTime = [LXWakeupAndSleepTimes sharedInstance].sleepTime;
            break;
            
        case kGradientTimeTypeStatic:
        default:
            break;
    }
    
    return baseTime + self.offset;
}

- (NSTimeInterval)timeIntervalSinceSunrise {
    return [self timeIntervalSinceMidnight] - [EDSunriseSet sharedManager].sunriseSeconds;
}

- (NSComparisonResult)compare:(LXGradientTime *)otherTime {
    NSTimeInterval thisTimeInterval = [self timeIntervalSinceMidnight];
    
    NSTimeInterval otherTimeInterval = [otherTime timeIntervalSinceMidnight];
    
    return otherTimeInterval > thisTimeInterval ? NSOrderedAscending : thisTimeInterval > otherTimeInterval ? NSOrderedDescending : NSOrderedSame;
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    LXGradientTime *copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        copy.timeType = self.timeType;
        copy.offset = self.offset;
    }
    
    return copy;
}

@end
