//
//  LXGradientDetailViewController.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/28/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientDetailViewController.h"
#import "LXGradientInfo.h"
#import "LXGradientView.h"
#import "NSDate+Extensions.h"

@interface LXGradientDetailViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet LXGradientView *gradientView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation LXGradientDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.gradientView.gradientDirection = SAMGradientViewDirectionVertical;
    self.gradientView.topMargin = self.scrollView.frame.size.height/2.0f;
    self.gradientView.bottomMargin = self.scrollView.frame.size.height/2.0f;
    
    self.gradientView.frame = CGRectMake(0, 0, CGRectGetWidth(self.gradientView.frame), 1200 + self.scrollView.frame.size.height);

    self.gradientView.gradientInfo = _gradientInfo;
    self.gradientView.gradientDirection = SAMGradientViewDirectionVertical;
    [self updateScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)setGradientInfo:(LXGradientInfo *)gradientInfo {
    _gradientInfo = gradientInfo;
    if (self.isViewLoaded) {
        self.gradientView.gradientInfo = gradientInfo;
    }
}

#pragma mark helpers
- (void)updateScrollView {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 1200 + self.scrollView.frame.size.height);
//    self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.frame.size.height/2.0f, 0, -self.scrollView.frame.size.height/2.0f, 0);
    self.gradientView.clipsToBounds = NO;

    
}

#pragma mark time helpers

- (void)updateTime {
    
    CGFloat middlePos = self.scrollView.contentOffset.y + self.scrollView.contentInset.top;
    
    CGFloat percentOfDay = MAX(MIN((middlePos * 100.0f)/(1200), 100), 0);
    
    
    NSDate *time = [[[NSDate date] floor] dateByAddingTimeInterval:percentOfDay * 36 * 24];
    
    self.timeLabel.text = [time timeString];
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateTime];
}

- (IBAction)buttonTapped:(id)sender {
    [self updateTime];
}
@end
