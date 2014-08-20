//
//  LXLightSelectorViewController.m
//  Lifxadian
//
//  Created by Arshad Tayyeb on 7/14/14.
//  Copyright (c) 2014 Snarshad Development Labs. All rights reserved.
//

#import "LXLightSelectorViewController.h"
#import "LXDetailViewController.h"
#import <LIFXKit/LIFXKit.h>
#import "LXLightTableViewCell.h"

typedef NS_ENUM(NSInteger, TableSection) {
	TableSectionLights = 0,
	TableSectionTags = 1,
};

@interface LXLightSelectorViewController () <LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) LFXNetworkContext *lifxNetworkContext;

@property (nonatomic) NSArray *lights;
@property (nonatomic) NSArray *lightCollections;
@property (nonatomic) LXDetailViewController *detailViewController;

@end

@implementation LXLightSelectorViewController

- (LXDetailViewController *)detailViewController {
    if (!_detailViewController) {
        _detailViewController = [[LXDetailViewController alloc] initWithNibName:@"LXDetailViewController" bundle:nil];
    }
    return _detailViewController;
}

- (void)addViews {
    UINavigationItem *_navItem = [[_navBar items] lastObject];
    
    [_navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
        [self addViews];
		self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
		[self.lifxNetworkContext addNetworkContextObserver:self];
		[self.lifxNetworkContext.allLightsCollection addLightCollectionObserver:self];
	}
	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lifxNetworkContext = [LFXClient sharedClient].localNetworkContext;
    [self.lifxNetworkContext addNetworkContextObserver:self];
    [self.lifxNetworkContext.allLightsCollection addLightCollectionObserver:self];

//    [self.tableView registerClass:[LXLightTableViewCell class] forCellReuseIdentifier:@"LXLightTableViewCell"];
    [self addViews];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateTitle];
	[self updateLights];
	[self updateTags];
}

- (void)updateLights
{
	self.lights = self.lifxNetworkContext.allLightsCollection.lights;
	[self.tableView reloadData];
}

- (void)updateTags
{
    NSMutableArray *collections = [NSMutableArray arrayWithArray:self.lifxNetworkContext.taggedLightCollections];
    [collections addObject:self.lifxNetworkContext.allLightsCollection];
    self.lightCollections = collections;
	[self.tableView reloadData];
}

- (void)updateTitle
{
	self.title = [NSString stringWithFormat:@"LIFX Browser (%@)", self.lifxNetworkContext.isConnected ? @"connected" : @"searching"];
}

#pragma mark - LFXNetworkContextObserver

- (void)networkContextDidConnect:(LFXNetworkContext *)networkContext
{
	NSLog(@"Network Context Did Connect");
	[self updateTitle];
}

- (void)networkContextDidDisconnect:(LFXNetworkContext *)networkContext
{
	NSLog(@"Network Context Did Disconnect");
	[self updateTitle];
}

- (void)networkContext:(LFXNetworkContext *)networkContext didAddTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
	NSLog(@"Network Context Did Add Tagged Light Collection: %@", collection.tag);
	[collection addLightCollectionObserver:self];
	[self updateTags];
}

- (void)networkContext:(LFXNetworkContext *)networkContext didRemoveTaggedLightCollection:(LFXTaggedLightCollection *)collection
{
	NSLog(@"Network Context Did Remove Tagged Light Collection: %@", collection.tag);
	[collection removeLightCollectionObserver:self];
	[self updateTags];
}


#pragma mark - LFXLightCollectionObserver

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
	NSLog(@"Light Collection: %@ Did Add Light: %@", lightCollection, light);
	[light addLightObserver:self];
	[self updateLights];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
	NSLog(@"Light Collection: %@ Did Remove Light: %@", lightCollection, light);
	[light removeLightObserver:self];
	[self updateLights];
}

#pragma mark - LFXLightObserver

- (void)light:(LFXLight *)light didChangeLabel:(NSString *)label
{
	NSLog(@"Light: %@ Did Change Label: %@", light, label);
	NSUInteger rowIndex = [self.lights indexOfObject:light];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowIndex inSection:TableSectionLights]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch ((TableSection)section)
	{
		case TableSectionLights:	return self.lights.count;
		case TableSectionTags:		return self.lightCollections.count;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch ((TableSection)section)
	{
		case TableSectionLights:	return @"Lights";
		case TableSectionTags:		return @"Tags";
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    LXLightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LXLightTableViewCell"];
	
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LXLightTableViewCell" owner:self options:nil];
        cell = (LXLightTableViewCell *)[nib objectAtIndex:0];
    }
    
	switch ((TableSection)indexPath.section)
	{
		case TableSectionLights:
		{
			LFXLight *light = self.lights[indexPath.row];
			
//			cell.textLabel.text = light.label;
//			cell.detailTextLabel.text = light.deviceID;
            cell.type = kLightCellTypeLight;
            cell.title = light.label;
            cell.color = [light.color UIColor];

            break;
		}
		case TableSectionTags:
		{
            LFXLightCollection *lightCollection = self.lightCollections[indexPath.row];
            
            if ([lightCollection isKindOfClass:[LFXTaggedLightCollection class]]) {
                cell.title = [(LFXTaggedLightCollection *)lightCollection tag];
                cell.type = kLightCellTypeTagged;
            } else {
                cell.type = kLightCellTypeAll;
                cell.title = lightCollection.label;
            }
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i devices", (int)lightCollection.lights.count];
			
			break;
		}
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id detailItem;
    
    switch ((TableSection)indexPath.section)
    {
        case TableSectionLights:
            detailItem = self.lights[indexPath.row];
            break;
        case TableSectionTags:
            detailItem = self.lightCollections[indexPath.row];
            break;
    }

    [self showDetailView:detailItem];
}


- (void)showDetailView:(id)detailItem {
    
    self.detailViewController.detailItem = detailItem;
    [self addChildViewController:self.detailViewController];
    [self.detailViewController didMoveToParentViewController:self];
    self.detailViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.detailViewController.view];
}

- (void)dismissDetailView {
    [self.detailViewController.view removeFromSuperview];
    [self.detailViewController removeFromParentViewController];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
	{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		id detailItem;
		switch ((TableSection)indexPath.section)
		{
			case TableSectionLights:
				detailItem = self.lights[indexPath.row];
				break;
			case TableSectionTags:
				detailItem = self.lightCollections[indexPath.row];
				break;
		}
        [[segue destinationViewController] setDetailItem:detailItem];
    }
}

 - (void)close:(id)sender {
     NSLog(@"Close");
     [self dismissViewControllerAnimated:YES completion:^{
     }];
 }
@end
