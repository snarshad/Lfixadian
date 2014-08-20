//
//  LXGradientInfo+Presets.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/22/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientInfo.h"

@interface LXGradientInfo (Presets)
+ (NSArray *)allPresets;
+ (LXGradientInfo *)daylightSkyColors;
+ (LXGradientInfo *)circadianColorsBasedOnSunrise;
+ (LXGradientInfo *)circadianColorsBasedOnBedtime;
@end
