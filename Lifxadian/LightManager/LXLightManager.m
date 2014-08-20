//
//  LightManager.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/14/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXLightManager.h"
#import "LXLightSelectorViewController.h"
#import <LIFXKit/LIFXKit.h>
#import "LFXHSBKColor+UIColor.h"

SINGLETON_IMPLEMENTATION(LXLightManager)
NSString *const kSelectedLightsWillChangeNotification = @"kSelectedLightsWillChange";
NSString *const kSelectedLightsDidChangeNotification = @"kSelectedLightsDidChange";

@interface LXLightManager () <LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver>
@property (nonatomic) LFXNetworkContext *lifxNetworkContext;
@end

@implementation LXLightManager

- (instancetype)init {
    if (self = [super init]) {
        self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
        [self.lifxNetworkContext addNetworkContextObserver:self];
        [self.lifxNetworkContext.allLightsCollection addLightCollectionObserver:self];
        
    }
    return self;
}

- (void)presentLightSelectorInParentViewController:(UIViewController *)parentViewController {
    LXLightSelectorViewController *lightSelector = [[LXLightSelectorViewController alloc] initWithNibName:@"LXLightSelectorViewController" bundle:nil];
    
    [parentViewController presentViewController:lightSelector animated:YES completion:^{
        
    }];
    
}

- (void)setAllLightsToColor:(UIColor *)color {
    LFXHSBKColor *lColor = [color LFXHSBKColor];
    
    if (lColor) {
        [self.lifxNetworkContext.allLightsCollection setColor:lColor];
    }
}

#pragma mark - LFXNetworkContextObserver

- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext
{
}

- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext
{
}

- (void)networkContext:(LFXNetworkContext *)networkContext didAddTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
}

- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
}

#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
}

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
}


@end
