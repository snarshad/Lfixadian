//
//  LFXHSBKColor+NSCoding.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/23/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LFXHSBKColor+NSCoding.h"

@implementation LFXHSBKColor (NSCoding)
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:@(self.hue) forKey:@"hue"];
    [coder encodeObject:@(self.saturation) forKey:@"saturation"];
    [coder encodeObject:@(self.brightness) forKey:@"brightness"];
    [coder encodeObject:@(self.kelvin) forKey:@"kelvin"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.hue = [[coder decodeObjectForKey:@"hue"] floatValue];
        self.saturation = [[coder decodeObjectForKey:@"saturation"] floatValue];
        self.brightness = [[coder decodeObjectForKey:@"brightness"] floatValue];
        self.kelvin = [[coder decodeObjectForKey:@"kelvin"] integerValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return @{
             @"hue" : @(self.hue),
             @"saturation" : @(self.saturation),
             @"brightness" : @(self.brightness),
             @"kelvin" : @(self.kelvin),
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.hue = [dictionary[@"hue"] floatValue];
        self.saturation = [dictionary[@"saturation"] floatValue];
        self.brightness = [dictionary[@"brightness"] floatValue];
        self.kelvin = [dictionary[@"kelvin"] integerValue];
    }
    return self;
}

@end
