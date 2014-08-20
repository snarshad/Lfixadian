//
//  ColorTempManager.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/2/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "ColorTempManager.h"
#import "UIColor+Extensions.h"
#import "UIColor+LFXExtensions.h"

@interface ColorTempManager ()
@end

#define kMidnight 0;
#define kSunrise 30;
#define kMidMorning 30;

static NSDictionary *s_colorTempsDict = nil;

static ColorTempManager *s_colorTempManager = nil;

@implementation ColorTempManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_colorTempManager = [[ColorTempManager alloc] init];
    });
    return s_colorTempManager;
}

+ (NSDictionary *)colorTemperatures {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_colorTempsDict = [@{} mutableCopy];
    });
    
    
    
    return s_colorTempsDict;
}
@end


//
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


//at sunrise sunset=182,126,91
//noon=192,191,173
//clouds, haze=189,190,192
//overcast=174,183,190


//def wav2RGB(wavelength):
//w = int(wavelength)
//
//# colour
//if w >= 380 and w < 440:
//R = -(w - 440.) / (440. - 350.)
//G = 0.0
//B = 1.0
//elif w >= 440 and w < 490:
//R = 0.0
//G = (w - 440.) / (490. - 440.)
//B = 1.0
//elif w >= 490 and w < 510:
//R = 0.0
//G = 1.0
//B = -(w - 510.) / (510. - 490.)
//elif w >= 510 and w < 580:
//R = (w - 510.) / (580. - 510.)
//G = 1.0
//B = 0.0
//elif w >= 580 and w < 645:
//R = 1.0
//G = -(w - 645.) / (645. - 580.)
//B = 0.0
//elif w >= 645 and w <= 780:
//R = 1.0
//G = 0.0
//B = 0.0
//else:
//R = 0.0
//G = 0.0
//B = 0.0
//
//# intensity correction
//if w >= 380 and w < 420:
//SSS = 0.3 + 0.7*(w - 350) / (420 - 350)
//elif w >= 420 and w <= 700:
//SSS = 1.0
//elif w > 700 and w <= 780:
//SSS = 0.3 + 0.7*(780 - w) / (780 - 700)
//else:
//SSS = 0.0
//SSS *= 255
//
//return [int(SSS*R), int(SSS*G), int(SSS*B)]
