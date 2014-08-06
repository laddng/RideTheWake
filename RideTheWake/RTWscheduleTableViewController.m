//
//  RTWscheduleTableViewController.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/29/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWscheduleTableViewController.h"
#import "RTWtimeTableViewCell.h"

@interface RTWscheduleTableViewController ()

@property NSArray *stopNames;
@property NSArray *stopTimes;

@end

@implementation RTWscheduleTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _stopNames = @[@"Last Resort Bar", @"Tate's Bar", @"Finnegann's Bar", @"Benson"];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Schedule", _routeID];
        
    [self loadRouteSchedule];
    
}

- (void) loadRouteSchedule
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

// Configure each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTWtimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_stopNames objectAtIndex:section];
}

@end