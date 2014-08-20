//
//  LXLightTableViewCell.h
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/20/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum eLightCellType {
    kLightCellTypeLight = 0,
    kLightCellTypeTagged = 1,
    kLightCellTypeAll = 2,
} eLightCellType;

@interface LXLightTableViewCell : UITableViewCell
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, readwrite) eLightCellType type;
@property (strong, nonatomic) IBOutlet UIImageView *bulbImageView;
@end
