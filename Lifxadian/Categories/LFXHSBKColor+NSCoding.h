//
//  LFXHSBKColor+NSCoding.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/23/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LFXHSBKColor.h"

@interface LFXHSBKColor (NSCoding)
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end
