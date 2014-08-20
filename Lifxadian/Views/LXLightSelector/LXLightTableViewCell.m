//
//  LXLightTableViewCell.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/20/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXLightTableViewCell.h"
#import "LXLightBulbImageView.h"
#import "UIImage+Tint.h"

@interface LXLightTableViewCell () <UIGestureRecognizerDelegate>
//@property (strong, nonatomic) IBOutlet LXLightBulbImageView *bulbImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LXLightTableViewCell

- (NSString *) reuseIdentifier {
    return @"LXLightTableViewCell";
}
- (void)awakeFromNib {
    // Initialization code
//    self.bulbImageView.frame = CGRectMake(5, 5, 30, 30);
//    self.bulbImageView.backgroundColor = [UIColor blueColor];
    
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapR.delegate = self;
    [self.imageView addGestureRecognizer:tapR];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setColor:(UIColor *)color {
    _color = color;
    if (self.type == kLightCellTypeLight) {
        self.bulbImageView.image = [[UIImage imageNamed:@"lightbulb"] imageTintedWithColor:color];
    }
//    self.bulbImageView.color = color;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setType:(eLightCellType)type {
    _type = type;
//    self.bulbImageView.hidden = (type != kLightCellTypeLight);
    
    switch (type) {
        case kLightCellTypeLight:
            self.bulbImageView.image = [[UIImage imageNamed:@"lightbulb"] imageTintedWithColor:self.color];
            break;
        case kLightCellTypeTagged:
            self.bulbImageView.image = [UIImage imageNamed:@"multi-bulb"];
            break;
        case kLightCellTypeAll:
            self.bulbImageView.image = [UIImage imageNamed:@"all-bulbs"];
            break;
            
        default:
            break;
    }

//    self.bulbImageView.transform = CGAffineTransformMakeScale(.7, .7);
}

- (void)imageTapped:(UITapGestureRecognizer *)tapR {
    if (tapR.state == UIGestureRecognizerStateEnded) {
        NSLog(@"TAPPED IMAGE");
    }
}

@end
