//
//  RTWscheduleTableViewController.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/29/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWscheduleTableViewController.h"
#import "RTWtimeTableViewCell.h"
#import "RTWShuttleStop.h"

@interface RTWscheduleTableViewController ()

@property NSMutableArray *stopNames;
@property NSMutableArray *stopTimes;

@end

@implementation RTWscheduleTableViewController

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Schedule Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Schedule", _routeID];
    
    _scheduleInfo.text = [_stops objectAtIndex:[_stops count]-1];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_stops count]-1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RTWtimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
    
    cell.time.text = [[_stops objectAtIndex:indexPath.row] stopTimes];
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [[_stops objectAtIndex:section] stopName];
    
}

@end