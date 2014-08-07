//
//  RTWmainTableViewController.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/29/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWmainTableViewController.h"
#import "RTWmapViewController.h"
#import "RTWrouteTableViewCell.h"
#import "RTWrouteInformation.h"

@interface RTWmainTableViewController ()

@property (strong, nonatomic) NSMutableArray *dayRoutes;

@property (strong, nonatomic) NSMutableArray *nightRoutes;

@property int selectedView;

@end

@implementation RTWmainTableViewController

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Main Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _dayRoutes = [[NSMutableArray alloc] init];
    
    _nightRoutes = [[NSMutableArray alloc] init];
    
    _selectedView = 0;
    
    [self loadShuttleRouteNamesAndStops];
    
}

- (IBAction) didChangeSelectedView: (id) sender
{
    
    _selectedView = (int)_segmentControlItem.selectedSegmentIndex;
 
    [self.tableView reloadData];
    
}

- (void) loadShuttleRouteNamesAndStops
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shuttleNamesAndStops" ofType:@"csv"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < [fileLines count]; i++)
    {
        
        NSArray *lineItem = [fileLines[i] componentsSeparatedByString:@"|"];
        
        RTWrouteInformation *routeObject = [[RTWrouteInformation alloc] init];
        
        routeObject.routeName = [lineItem objectAtIndex:0];
        
        routeObject.routeClass = [lineItem objectAtIndex:1];
        
        routeObject.routeID = [lineItem objectAtIndex:2];
        
        routeObject.routeStops = [lineItem objectAtIndex:3];
        
        routeObject.zoomLevel = [[lineItem objectAtIndex:4] intValue];
        
        if ([[lineItem objectAtIndex:1] isEqualToString:@"day"])
        {
            
            [_dayRoutes addObject:routeObject];
            
        }
        else if ([[lineItem objectAtIndex:1] isEqualToString:@"night"])
        {
         
            [_nightRoutes addObject:routeObject];
            
        }
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedView == 0)
    {
        
        return [_dayRoutes count];

    }
    
    else
    {
        return [_nightRoutes count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RTWrouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"route" forIndexPath:indexPath];
    
    RTWrouteInformation *info = [[RTWrouteInformation alloc] init];
    
    
    if (_selectedView == 0)
    {
        
        info = [_dayRoutes objectAtIndex:indexPath.row];
        
        cell.routeName.text = [info routeName];
        
        [cell.routeStops setText:[info routeStops]];
        
    }
    
    else
    {
        
        info = [_nightRoutes objectAtIndex:indexPath.row];
        
        cell.routeName.text = [info routeName];
        
        [cell.routeStops setText:[info routeStops]];
        
    }
    
    cell.routeStops.contentInset = UIEdgeInsetsMake(-4,-5,0,0);
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"mapVC"])
    {
        
        RTWmapViewController *mapVC = [segue destinationViewController];
        
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        
        RTWrouteInformation *info = [[RTWrouteInformation alloc] init];
        
        if (_selectedView == 0)
        {
            
            info = [_dayRoutes objectAtIndex:selectedRow.row];
            
            mapVC.routeID = [info routeName];
            mapVC.routeIDName = [info routeID];
            mapVC.zoomLevel = [info zoomLevel];
        }
        
        else
        {
            
            info = [_nightRoutes objectAtIndex:selectedRow.row];
            
            mapVC.routeID = [info routeName];
            mapVC.routeIDName = [info routeID];
            mapVC.zoomLevel = [info zoomLevel];
            
        }

        
    }

}

- (IBAction)viewDidUnwind:(UIStoryboardSegue *)segue
{
    
}

@end