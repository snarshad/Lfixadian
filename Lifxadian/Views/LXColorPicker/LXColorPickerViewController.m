//
//  LXColorPickerViewController.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/23/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXColorPickerViewController.h"
#import "NKOColorPickerView.h"

@interface LXColorPickerViewController ()
@property (nonatomic, strong) NKOColorPickerView *colorPickerView;
@property (nonatomic, strong) UILabel *hueLabel;
@property (nonatomic, strong) UILabel *brightnessLabel;
@property (nonatomic, strong) UILabel *saturationLabel;
@property (nonatomic, strong) UILabel *kelvinLabel
;

@end

@implementation LXColorPickerViewController

- (instancetype)initWithStartColor:(UIColor *)startColor delegate:(id<LXColorPickerViewControllerDelegate>)delegate {
    if (self = [super init]) {
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 240)];
        self.startColor = startColor;
        self.delegate = delegate;
        [self setupColorPickerView];
    }
    return self;
}

- (void)resetToStartColor {
    self.colorPickerView.color = self.startColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLabels {
    
}

- (void)setupColorPickerView {
    //Color did change block declaration
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        if ([self.delegate respondsToSelector:@selector(didSwipeToColor:)]) {
            [self.delegate didSwipeToColor:color];
        }
        [self.delegate didChooseColor:color];
    };
    
    if (!_colorPickerView) {
        _colorPickerView = [[NKOColorPickerView alloc] initWithFrame:self.view.bounds color:self.startColor andDidChangeColorBlock:colorDidChangeBlock];
        [self.view addSubview:_colorPickerView];

    }
}

@end
