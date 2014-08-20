//
//  LXGradientListViewController.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/27/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXGradientListViewController.h"
#import "LXGradientInfo+Presets.h"
#import "LXGradientInfoTableViewCell.h"

NSString *const kSectionNamePresets = @"Presets";
NSString *const kSectionNameSaved = @"Saved";


@interface LXGradientListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *sections;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation LXGradientListViewController


- (void)commonInit {
    self.sections = @[kSectionNamePresets, kSectionNameSaved];

    
}
                      
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
    [self commonInit];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view cell helpers

- (NSArray *)gradientsInSection:(NSInteger)section {
    NSString *sectionName = [self.sections objectAtIndex:section];
    if ([sectionName isEqualToString:kSectionNamePresets]) {
        return [LXGradientInfo allPresets];
    } else if ([sectionName isEqualToString:kSectionNameSaved]) {
        //TODO:
        return nil;
    }
    return nil;
}

- (LXGradientInfo *)gradientInfoAtIndexPath:(NSIndexPath *)indexPath {
    return [self gradientsInSection:indexPath.section][indexPath.row];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self gradientsInSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LXGradientInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LXGradientInfoTableViewCell"];
//    if (!cell) {
//        cell = [LXGradientInfoTableViewCell cell];
//    }
//    
//    cell.gradientInfo = [self gradientInfoAtIndexPath:indexPath];
//    return cell;
    
    LXGradientInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LXGradientCell"];
    cell.gradientInfo = [self gradientInfoAtIndexPath:indexPath];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GradientDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LXGradientInfo *gradient = [self gradientInfoAtIndexPath:indexPath];
        
        [[segue destinationViewController] setGradientInfo:gradient];
    }
}
@end
