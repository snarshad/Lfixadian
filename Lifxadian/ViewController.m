//
//  ViewController.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 6/25/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "ViewController.h"
#import "EDSunriseSet.h"
#import <CoreLocation/CoreLocation.h>
#import "LXLightSelectorButton.h"
#import "LXLightManager.h"
#import "LXGradientView.h"
#import "UIImage+Tint.h"
#import "LXGradientInfo.h"
#import "LXGradientTime.h"
#import "UIColor+Extensions.h"
#import "NSDate+Extensions.h"
#import "LXColorPickerViewController.h"
#import "LXGradientInfo+Presets.h"
#import "WYPopoverController.h"

@interface ViewController () <CLLocationManagerDelegate, UIGestureRecognizerDelegate, LXColorPickerViewControllerDelegate, WYPopoverControllerDelegate>
//@property (strong, nonatomic) EDSunriseSet *astroManager;
@property (strong, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) WYPopoverController* colorPopover;
@property (strong) CLLocation *lastKnownLocation;
@property (strong) NSDate *lastCheckDate;
@property (strong, nonatomic) IBOutlet LXLightSelectorButton *lightsButton;
@property (strong, nonatomic) IBOutlet UILabel *sliderCaptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *sliderCaption2Label;
@property (strong, nonatomic) IBOutlet UISlider *timeSlider;
@property (strong, nonatomic) IBOutlet LXGradientView *gradientView;
@property (strong, nonatomic) IBOutlet UIImageView *bulbImageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *bulbTapGR;

@end

@interface NSDate (Formatters)
- (NSString *)localTimeString;
@end

@implementation NSDate (Formatters)
+ (NSDateFormatter *)timeFormatter {
    static NSDateFormatter *g_df = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_df = [[NSDateFormatter alloc] init];
        g_df.timeStyle = NSDateFormatterShortStyle;
        g_df.dateStyle = NSDateFormatterNoStyle;
    });
    return g_df;
}

- (NSString *)localTimeString {
    return [[[self class] timeFormatter] stringFromDate:self];
}
@end

@implementation ViewController


- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 10000;
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            self.lastKnownLocation = [_locationManager location];
            [self updateCurrentValues];
            [_locationManager startUpdatingLocation];
        } else {
            [_locationManager startUpdatingLocation];
//            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}

//- (void)createSampleGradients {
//    LXGradientInfo *info = [[LXGradientInfo alloc] init];
//    info.name = @"gradient1";
//    info.description = @"First gradient";
//    
//    LXGradientTime *time0 = [LXGradientTime timeAfterMidnight:0];
//    LXGradientTime *time1 = [LXGradientTime timeWithHour:10 minutes:30];
//    LXGradientTime *time2 = [LXGradientTime sunriseTime];
//    LXGradientTime *time3 = [LXGradientTime sunsetTime];
//    LXGradientTime *time4 = [LXGradientTime middayTime];
//    LXGradientTime *time5 = [LXGradientTime sunriseTimeWithOffset:3600];
//    LXGradientTime *time6 = [LXGradientTime sunsetTimeWithOffset:-3600];
//    
//    
//    NSArray *daytimeSkyColors = @[[UIColor colorFromHexString:@"0B0851"],
//                                  [UIColor colorFromHexString:@"6300B4"],
//                                  [UIColor colorFromHexString:@"FC00CE"],
//                                  [UIColor colorFromHexString:@"FF5F00"],
//                                  [UIColor colorFromHexString:@"FFCF15"],
//                                  [UIColor colorFromHexString:@"F9FF86"],
//                                  [UIColor colorFromHexString:@"FEFFF3"],
//                               ];
//    LXGradientInfo *daylightSkyColorsInfo = [[LXGradientInfo alloc] init];
//    daylightSkyColorsInfo.name = @"Sky Colors";
//    daylightSkyColorsInfo.description = @"Colors of the sky during the day";
//
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[0] forTime:[LXGradientTime sunriseTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[1] forTime:[LXGradientTime sunriseTime]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[2] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[3] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[4] forTime:[LXGradientTime sunriseTimeWithOffset:+TIMEINTERVAL_ONE_HOUR*1.5]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[5] forTime:[LXGradientTime middayTime]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[4] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR*1.5]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[3] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[2] forTime:[LXGradientTime sunsetTimeWithOffset:-TIMEINTERVAL_ONE_HOUR/2]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[1] forTime:[LXGradientTime sunsetTime]];
//    [daylightSkyColorsInfo addColor:daytimeSkyColors[0] forTime:[LXGradientTime sunsetTimeWithOffset:+TIMEINTERVAL_ONE_HOUR/2]];
//    
//    
//    
//    
//    //these don't work
////    NSArray *colors = @[
////                           [UIColor redColor],
////                           [UIColor whiteColor],
////                           [UIColor greenColor],
////                           [UIColor blueColor],
////                           [UIColor orangeColor],
////                           [UIColor grayColor]
////                           ];
//
//    NSArray *colors = @[
//                        [UIColor greenColor],
//                        [UIColor greenColor],
//                        [UIColor whiteColor],
//                        [UIColor greenColor],
//                        [UIColor blueColor],
//                        [UIColor blueColor],
//                        [UIColor yellowColor]
//                        ];
//    
//    
//    [info addColor:colors[0] forTime:time1];
//    [info addColor:colors[1] forTime:time2];
//    [info addColor:colors[2] forTime:time3];
//    [info addColor:colors[3] forTime:time4];
//    [info addColor:colors[4] forTime:time5];
//    [info addColor:colors[5] forTime:time6];
//
//    NSLog(@"unsorted: %@", [info colorsByTime]);
//
//    NSLog(@"sorted: %@", [info sortedColorsAndTimes]);
//    
//    [self populateGradientView:daylightSkyColorsInfo];
//
////    [info saveToDisk];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bulbTapped:)];
    [self.bulbImageView addGestureRecognizer:tapR];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"lightbulb"] forState:UIControlStateNormal];
}


- (void)viewDidAppear:(BOOL)animated {
    [self locationManager];
    
    [self populateGradientView:[LXGradientInfo daylightSkyColors]];
//    [self createSampleGradients];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                            
- (IBAction)allOnTapped:(id)sender {
    NSLog(@"Location: %@", self.locationManager.location);

    [self.gradientView setGradientInfo:[LXGradientInfo daylightSkyColors]];
    [self updateCurrentValues];
}
#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.lastKnownLocation = [_locationManager location];
    [self updateCurrentValues];
        [manager startUpdatingLocation];
//    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.lastKnownLocation = [locations lastObject];

    [self updateCurrentValues];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Error from Location Manager: %@", error);
}
#pragma mark -

- (void)updateCurrentValues {
    if (self.lastKnownLocation) {
        [EDSunriseSet setSharedTimezone:[NSTimeZone defaultTimeZone] latitude:self.lastKnownLocation.coordinate.latitude longitude:self.lastKnownLocation.coordinate.longitude];
        
        self.sunriseLabel.text = [[[EDSunriseSet sharedManager] sunrise] localTimeString];
        self.sunsetLabel.text = [[[EDSunriseSet sharedManager] sunset] localTimeString];
        self.lastCheckDate = [NSDate date];
        
        self.timeSlider.value = [self percentSunForTime:[NSDate date]];
        [self sliderValueChanged:self.timeSlider];
    }
}

- (IBAction)selectLights:(id)sender {
    NSLog(@"Select Lights");
    [[LXLightManager sharedInstance] presentLightSelectorInParentViewController:self];
}


- (CGFloat)percentSunForTime:(NSDate *)date {
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:[EDSunriseSet sharedManager].sunrise];

    NSTimeInterval daytimeInterval = [[[EDSunriseSet sharedManager] sunset] timeIntervalSinceDate:[EDSunriseSet sharedManager].sunrise];
    
    return timeInterval/daytimeInterval;
}


- (void)setSunPercent:(CGFloat)percent {
    NSTimeInterval timeSinceSunrise = [[[EDSunriseSet sharedManager] sunset] timeIntervalSinceDate:[EDSunriseSet sharedManager].sunrise] * percent/100.0;
    
    NSDate *newDate = [[EDSunriseSet sharedManager].sunrise dateByAddingTimeInterval:timeSinceSunrise];
    
    self.sliderCaption2Label.text = [newDate localTimeString];
    
}

- (void)setTimePercent:(CGFloat)percent {
    NSTimeInterval timeSinceMidnight = percent/100.0 * 3600 * 24;
    
    NSDate *newDate = [[[NSDate date] floor] dateByAddingTimeInterval:timeSinceMidnight];
    
    self.sliderCaption2Label.text = [newDate localTimeString];
    
}

- (IBAction)sliderValueChanged:(UISlider *)slider {
    self.sliderCaptionLabel.text = [NSString stringWithFormat:@"%2.0f%%", slider.value * 100.0];
    [self setTimePercent:slider.value * 100.0];
    
    UIColor *color = [self.gradientView colorForPercent:slider.value];
    
    self.timeSlider.thumbTintColor = color;
    self.timeSlider.tintColor = color;
    self.bulbImageView.image = [[UIImage imageNamed:@"lightbulb"] imageTintedWithColor:color];
    
//    [[LXLightManager sharedInstance] setAllLightsToColor:color];
}

- (void)populateGradientView:(LXGradientInfo *)gradientInfo {
    self.gradientView.gradientDirection = SAMGradientViewDirectionHorizontal;

    self.gradientView.gradientInfo = gradientInfo;

//    self.gradientView.gradientLocations = @[@(0.0),
//                                            @(0.3),
//                                            @(0.4),
//                                            @(0.7),
//                                            @(1.0)];
//    self.gradientView.gradientColors = @[[UIColor greenColor],
//                                         [UIColor blueColor],
//                                         [UIColor whiteColor],
//                                         [UIColor blueColor],
//                                         [UIColor yellowColor],
//                                         [UIColor blackColor]
//                                         ];

}
#pragma mark -
- (WYPopoverController *)colorPopover {
    if (!_colorPopover) {
        LXColorPickerViewController *colorPickerVC = [[LXColorPickerViewController alloc] initWithStartColor:[UIColor whiteColor] delegate:self];
        _colorPopover = [[WYPopoverController alloc] initWithContentViewController:colorPickerVC];
        _colorPopover.popoverContentSize = colorPickerVC.view.frame.size; 
        _colorPopover.delegate = self;
    }
    return _colorPopover;
}

#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (IBAction)bulbTapped:(UITapGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateEnded) {
        NSLog(@"TAPPED");
        
        [self.colorPopover presentPopoverFromRect:self.bulbImageView.frame inView:self.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    }

}

#pragma mark LXColorPickerViewControllerDelegate
- (void)didChooseColor:(UIColor *)color {
    self.bulbImageView.image = [[UIImage imageNamed:@"lightbulb"] imageTintedWithColor:color];
    
//    [[LXLightManager sharedInstance] setAllLightsToColor:color];
}


@end
