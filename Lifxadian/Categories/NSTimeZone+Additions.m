//
//  NSTimeZone+Additions.m
//  donna
//
//  Created by Arshad Tayyeb on 3/7/12.
//  Copyright (c) 2012 Incredible Labs. All rights reserved.
//

#import "NSTimeZone+Additions.h"

@implementation NSTimeZone (Additions)

- (NSString *)stringFromGMTForDate:(NSDate *)date
{
    NSInteger offset = [self secondsFromGMTForDate:date] / 60;
    NSString *sign = offset < 0 ? @"-" : @"+";
    if( offset < 0 )
        offset *= -1;
    return [NSString stringWithFormat:@"%@%02d%02d", sign, offset / 60, offset % 60];
}

@end
