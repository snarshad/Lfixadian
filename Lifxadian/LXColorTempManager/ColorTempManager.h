//
//  ColorTempManager.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/2/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoundationMacros.h"

@interface ColorTempManager : NSObject
+ (instancetype)sharedManager;
@property (nonatomic, strong) NSDateComponents *sunrise;
@property (nonatomic, strong) NSDateComponents *sunset;
@end

