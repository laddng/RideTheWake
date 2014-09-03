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
#import "RTWShuttleInfoDelegate.h"

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

    NSURL *serverURLPath = [[NSURL alloc] initWithString:@"http://shuttle.cs.wfu.edu/shuttle/stops/shuttleInformation.xml"];
    
    NSXMLParser *fileParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfURL:serverURLPath]];

    
    RTWShuttleInfoDelegate *xmlParserDelegate = [[RTWShuttleInfoDelegate alloc] initXmlParser];
    
    [fileParser setDelegate:xmlParserDelegate];
    
    [fileParser parse];
    
    _dayRoutes = xmlParserDelegate.dayRoutes;
    
    _nightRoutes = xmlParserDelegate.nightRoutes;
    
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
        
        cell.routeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ShuttleIcon",[info routeID]]];
        
    }
    
    else
    {
        
        info = [_nightRoutes objectAtIndex:indexPath.row];
        
        cell.routeName.text = [info routeName];
        
        [cell.routeStops setText:[info routeStops]];
        
        cell.routeIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@ShuttleIcon",[info routeID]]];
        
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
        
        if (_selectedView == 0)
        {
            
            mapVC.routeInfo = [_dayRoutes objectAtIndex:selectedRow.row];

        }
        
        else
        {
            
            mapVC.routeInfo = [_nightRoutes objectAtIndex:selectedRow.row];
        
        }

        
    }

}

- (IBAction)viewDidUnwind:(UIStoryboardSegue *)segue
{
    
}

@end