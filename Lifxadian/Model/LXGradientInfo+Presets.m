//
//  LXGradientInfo+Presets.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/22/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientInfo+Presets.h"
#import "LXGradientTime.h"
#import "UIColor+Extensions.h"
#import "NSDate+Extensions.h"

@implementation LXGradientInfo (Presets)
+ (NSArray *)allPresets {
    return @[[self daylightSkyColors], [self circadianColorsBasedOnSunrise], [self circadianColorsBasedOnBedtime]];
}

+ (LXGradientInfo *)daylightSkyColors {
    static LXGradientInfo *s_daylightSky = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *daytimeSkyColors = @[[UIColor colorFromHexString:@"0B0851"],
                                      [UIColor colorFromHexString:@"6300B4"],
                                      [UIColor colorFromHexString:@"FC00CE"],
                                      [UIColor colorFromHexString:@"FF5F00"],
                                      [UIColor colorFromHexString:@"FFCF15"],
                                      [UIColor colorFromHexString:@"F9FF86"],
                                      [UIColor colorFromHexString:@"FEFFF3"],
                                      ];

        LXGradientInfo *info = [[LXGradientInfo alloc] init];
        info.name = @"Sky Colors";
        info.gradientDescription = @"Colors of the sky during the day";
        
        [info addColor:daytimeSkyColors[0] forTime:[LXGradientTime sunriseTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:daytimeSkyColors[1] forTime:[LXGradientTime sunriseTime]];
        [info addColor:daytimeSkyColors[2] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:daytimeSkyColors[3] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR]];
        [info addColor:daytimeSkyColors[4] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR*1.5]];
        [info addColor:daytimeSkyColors[5] forTime:[LXGradientTime middayTime]];
        [info addColor:daytimeSkyColors[4] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR*1.5]];
        [info addColor:daytimeSkyColors[3] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR]];
        [info addColor:daytimeSkyColors[2] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:daytimeSkyColors[1] forTime:[LXGradientTime sunsetTime]];
        [info addColor:daytimeSkyColors[0] forTime:[LXGradientTime sunsetTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
        s_daylightSky = info;
    });
    return s_daylightSky;

}


+ (LXGradientInfo *)circadianColorsBasedOnSunrise {
    static LXGradientInfo *s_circadianSun = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *colors = @[[UIColor colorFromHexString:@"0B0851"],
                                      [UIColor colorFromHexString:@"6300B4"],
                                      [UIColor colorFromHexString:@"FC00CE"],
                                      [UIColor colorFromHexString:@"FF5F00"],
                                      [UIColor colorFromHexString:@"FFCF15"],
                                      [UIColor colorFromHexString:@"F9FF86"],
                                      [UIColor colorFromHexString:@"FEFFF3"],
                                      ];
        
        LXGradientInfo *info = [[LXGradientInfo alloc] init];
        info.name = @"Circadian Colors (daytime)";
        info.gradientDescription = @"Matches ideal circadian colors based on sunrise and sunset";
        
        [info addColor:colors[0] forTime:[LXGradientTime sunriseTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:colors[1] forTime:[LXGradientTime sunriseTime]];
        [info addColor:colors[2] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:colors[3] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR]];
        [info addColor:colors[4] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR*1.5]];
        [info addColor:colors[5] forTime:[LXGradientTime middayTime]];
        [info addColor:colors[4] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR*1.5]];
        [info addColor:colors[3] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR]];
        [info addColor:colors[2] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:colors[1] forTime:[LXGradientTime sunsetTime]];
        [info addColor:colors[0] forTime:[LXGradientTime sunsetTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
        s_circadianSun = info;
    });
    return s_circadianSun;
}

//Candle: 2300K
//Tungsten: 2700K
//Halogen: 3400K
//Fluorescent: 4200K
//Daylight: 5000K


//When you wake up, set the bulb to an orange hue from the colors menu, with a brightness of about 65%.
//In the mid-morning, switch to the whites menu to select a medium-white hue. Turn up the brightness to about 80%.
//Around mid-day, ramp up to 100% brightness and a bluish-white tint.
//In the mid-afternoon, turn it back down to a warm white with about 75% brightness
//
//At dinner time, switch back to the colors menu and set the bulb to a pleasant yellow-orange hue at around 55% brightness.
//
//When you’re getting ready for bed, ramp down to a reddish-orange hue and 30% brightness or less.


+ (LXGradientInfo *)circadianColorsBasedOnBedtime {
    static LXGradientInfo *s_circadianBedtime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *colors = @[[UIColor colorFromHexString:@"0B0851"],
                            [UIColor colorFromHexString:@"6300B4"],
                            [UIColor colorFromHexString:@"FC00CE"],
                            [UIColor colorFromHexString:@"FF5F00"],
                            [UIColor colorFromHexString:@"FFCF15"],
                            [UIColor colorFromHexString:@"F9FF86"],
                            [UIColor colorFromHexString:@"FEFFF3"],
                            ];
        
        LXGradientInfo *info = [[LXGradientInfo alloc] init];
        info.name = @"Circadian Colors (sleep helper)";
        info.gradientDescription = @"Matches ideal circadian colors based on your wake and sleep time";
        
        [info addColor:colors[0] forTime:[LXGradientTime sunriseTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:colors[1] forTime:[LXGradientTime sunriseTime]];
        [info addColor:colors[2] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:colors[3] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR]];
        [info addColor:colors[4] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR*1.5]];
        [info addColor:colors[5] forTime:[LXGradientTime middayTime]];
        [info addColor:colors[4] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR*1.5]];
        [info addColor:colors[3] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR]];
        [info addColor:colors[2] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
        [info addColor:colors[1] forTime:[LXGradientTime sunsetTime]];
        [info addColor:colors[0] forTime:[LXGradientTime sunsetTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
        s_circadianBedtime = info;
    });
    return s_circadianBedtime;
}

@end
