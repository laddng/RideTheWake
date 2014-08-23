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
        
    [self loadRouteSchedule];
    
}

- (void) loadRouteSchedule
{
    
    _stopNames = [[NSMutableArray alloc] init];
    
    _stopTimes = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Stops", _routeIDName] ofType:@"csv"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < [fileLines count]-1; i++)
    {
     
        NSArray *lineItem = [fileLines[i] componentsSeparatedByString:@","];
        
        [_stopNames addObject:[lineItem objectAtIndex:2]];
        
        [_stopTimes addObject:[lineItem objectAtIndex:3]];
        
    }
    
    _scheduleInfo.text = [fileLines objectAtIndex:[fileLines count]-1];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_stopNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RTWtimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
    
    cell.time.text = [_stopTimes objectAtIndex:indexPath.section];
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [_stopNames objectAtIndex:section];
    
}

@end