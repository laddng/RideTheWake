//
//  RTWmapViewController.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/24/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWmapViewController.h"
#import "RTWscheduleTableViewController.h"

@interface RTWmapViewController ()

@end

@implementation RTWmapViewController

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Map Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:218/255.0 green:174/255.0 blue:77/255.0 alpha:1];
    
    self.navigationItem.title = _routeID;

    [self loadMapView];
    
    [self loadShuttleStopMarkers];
    
    [self loadRoutePath];
    
    //[self loadShuttlesCurrentLocation];

}

// Init Method for MapView
- (void) loadMapView
{
    
    // Get location of shuttle
    GMSCameraPosition *shuttle = [GMSCameraPosition cameraWithLatitude:_centerPointLatitude longitude:_centerPointLongitude zoom:_zoomLevel];
    
    NSLog(@"%f", _centerPointLongitude);
    
    // Init mapView with settings
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:shuttle];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;

    // Display mapView
    self.view = self.mapView;

}

/*
// Pin the shuttle's current location
- (void) loadShuttlesCurrentLocation
{
 
    // Get location from file off server
    NSURL *serverURLPath = [NSURL URLWithString:@"http://shuttle.cs.wfu.edu/iPhone/blackLine"];
    
    NSString *fileContents = [NSString stringWithContentsOfURL:serverURLPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileCoordinates = [fileContents componentsSeparatedByString:@","];
 
    // If shuttle is NOT offline
    if(([[fileCoordinates objectAtIndex:0] floatValue] != 0.0) && ([[fileCoordinates objectAtIndex:1] floatValue] != 0.0))
    {
 
        CLLocationCoordinate2D shuttleCoordinates = CLLocationCoordinate2DMake([[fileCoordinates objectAtIndex:0] floatValue], [[fileCoordinates objectAtIndex:1] floatValue]);
     
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        marker.position = shuttleCoordinates;
        marker.map = self.mapView;
        marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
 
    }
 
    else {
    
        UIAlertView *shuttleIsOffline = [[UIAlertView alloc] initWithTitle:@"Shuttle is offline" message:@"This route is currently not operating." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
 
        [shuttleIsOffline show];
        
    }
 
}
*/

// Load shuttle stop markers based on the route id
- (void) loadShuttleStopMarkers
{
    
    // Load file that contains coordinates of shuttle stops
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Stops", _routeIDName] ofType:@"csv"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    // Loop through csv file and get coordinates
    for (int i = 0; i < [fileLines count]; i++)
    {
        // New marker
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        NSArray *lineItem = [fileLines[i] componentsSeparatedByString:@","];
        
        // Stop coordinate
        marker.position = CLLocationCoordinate2DMake([[lineItem objectAtIndex:0] floatValue], [[lineItem objectAtIndex:1] floatValue]);
        
        // Stop name
        marker.snippet = [lineItem objectAtIndex:2];
        marker.map = self.mapView;
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        
    }

}

// Load route path based on the route id
- (void) loadRoutePath
{
    
    // Get route from csv file
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Route", _routeIDName] ofType:@"csv"];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    // Array of coordinates for route
    GMSMutablePath *polylineCoordinates = [GMSMutablePath path];

    // Loop through csv file and get coordinates
    for (int i = 0; i < [fileLines count]; i++)
    {
        NSArray *lineItem = [fileLines[i] componentsSeparatedByString:@","];
        
        [polylineCoordinates addCoordinate:CLLocationCoordinate2DMake([[lineItem objectAtIndex:0] floatValue], [[lineItem objectAtIndex:1] floatValue])];
        
    }
    
    // Create the polyline with coordinates and settings
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:polylineCoordinates];
    polyline.map = _mapView;
    polyline.strokeWidth = 8.f;
    polyline.strokeColor = [UIColor colorWithRed:0/255.0 green:179/255.0 blue:253/255.0 alpha:1];

}

// Segue to scheduleView by passing a route ID name
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // If making a segue to a mapView
    if ([[segue identifier] isEqualToString:@"scheduleVC"])
    {
        
        UINavigationController *navigationController = segue.destinationViewController;
        RTWscheduleTableViewController *scheduleVC = (RTWscheduleTableViewController * )navigationController.topViewController;
        
        scheduleVC.routeID = _routeID;
        scheduleVC.routeIDName = _routeIDName;
        
    }
    
}

- (IBAction)viewDidUnwind:(UIStoryboardSegue *)segue
{
    
}

@end