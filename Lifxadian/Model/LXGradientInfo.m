//
//  LXGradientInfo.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/21/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientInfo.h"
#import "UIApplication+SAMAdditions.h"
#import "LXGradientTime.h"
#import "UIColor+Extensions.h"
#import "LFXHSBKColor.h"
#import "LFXHSBKColor+NSCoding.h"
#import "LFXHSBKColor+UIColor.h"

static NSString* const kGuidKey = @"guid";
static NSString* const kNameKey = @"name";
static NSString* const kDescriptionKey = @"gradientDescription";
static NSString* const kColorsByTimeKey = @"colors";

@interface LXGradientInfo ()
@property (nonatomic, copy) NSString *guid;
@end

@interface LXGradientTime (_private)
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;
@end

@implementation LXGradientInfo

- (instancetype)init {
    if (self = [super init]) {
        self.guid = [[NSUUID UUID] UUIDString];
        _colorsByTime = [NSMutableArray array];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_guid forKey:kGuidKey];
    [coder encodeObject:_colorsByTime forKey:kColorsByTimeKey];
    [coder encodeObject:_gradientDescription forKey:kDescriptionKey];
    [coder encodeObject:_name forKey:kNameKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _guid = [coder decodeObjectForKey:kGuidKey];
        _name = [coder decodeObjectForKey:kNameKey];
        _gradientDescription = [coder decodeObjectForKey:kDescriptionKey];
        _colorsByTime = [coder decodeObjectForKey:kColorsByTimeKey];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _colorsByTime = [NSMutableArray array];
        _name = dictionary[@"name"];
        _gradientDescription = dictionary[kDescriptionKey];
        _guid = dictionary[@"guid"];

        for (NSDictionary *colorDict in dictionary[@"colors"]) {
            LXGradientTime *time = [[LXGradientTime alloc] initWithDictionary:colorDict[@"time"]];
            LFXHSBKColor *color = [[LFXHSBKColor alloc] initWithDictionary:colorDict];
            
            [self addColor:color forTime:time];
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableArray *colorsArray = [NSMutableArray array];
    
    for (NSDictionary *colorInfoDict in self.colorsByTime) {
        NSDictionary *colorDict = colorInfoDict[@"color"];
        NSDictionary *timeDict = [colorInfoDict[@"time"] dictionaryRepresentation];

        [colorsArray addObject:@{@"color" : colorDict, @"time" : timeDict}];
    }
    
    return @{@"name" : self.name ? self.name : @"",
             kDescriptionKey : self.gradientDescription ? self.gradientDescription : @"",
             @"guid" : self.guid,
             @"colors" : colorsArray
             };
}

#pragma mark -

- (void)saveToDisk {
    NSURL *fileURL = [[[UIApplication sharedApplication] sam_documentsDirectoryURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _guid]];

    NSDictionary *dict = [self dictionaryRepresentation];
    [dict writeToURL:fileURL atomically:YES];
    
    NSDictionary *newDict = [NSDictionary dictionaryWithContentsOfURL:fileURL];
    LXGradientInfo *newInfo = [[LXGradientInfo alloc] initWithDictionary:newDict];
    
    NSLog(@"NewInfo: %@", [newInfo dictionaryRepresentation]);
}


#pragma mark -
- (void)addColor:(id)color forTime:(LXGradientTime *)time {
    if (!_colorsByTime) {
        _colorsByTime = [NSMutableArray array];
    }

    LFXHSBKColor *lcolor = color;
    if ([color isKindOfClass:[UIColor class]]) {
        lcolor = [color LFXHSBKColor];
    }
    
    [self.colorsByTime addObject:@{@"color" : lcolor, @"time" : time}];
}

- (NSArray *)sortedColorsAndTimes {
    [self.colorsByTime sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[@"time"] compare:obj2[@"time"]];
    }];
    return [self colorsByTime];
}


@end
