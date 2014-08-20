//
//  LightManager.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/14/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoundationMacros.h"
#import <UIKit/UIKit.h>

extern NSString *const kSelectedLightsWillChangeNotification;
extern NSString *const kSelectedLightsDidChangeNotification;

@interface LXLightManager : NSObject

- (void)setAllLightsToColor:(UIColor *)color;

- (void)presentLightSelectorInParentViewController:(UIViewController *)parentViewController;
@end

SINGLETON_INTERFACE(LXLightManager)
