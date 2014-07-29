//
//  RTWmapViewController.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/24/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWmapViewController.h"

@interface RTWmapViewController ()

@end

@implementation RTWmapViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    [self loadMapView];
    
    [self loadShuttleStopMarkers];
    
    [self loadRoutePath];

}

// Init Method for MapView
- (void) loadMapView
{
    
    CLLocationCoordinate2D shuttleCoordinates = [self loadShuttlesCurrentLocation];
    
    // Get location of shuttle
    GMSCameraPosition *shuttle = [GMSCameraPosition cameraWithLatitude:shuttleCoordinates.latitude longitude:shuttleCoordinates.longitude zoom:15];
    
    // Init mapView with settings
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:shuttle];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;

    // Display mapView
    self.view = self.mapView;

}

// Pin the shuttle's current location
- (CLLocationCoordinate2D) loadShuttlesCurrentLocation
{
    
    // Get location from file off server
    NSURL *serverURLPath = [NSURL URLWithString:@"http://www.shuttle.cs.wfu/iPhone/blackLine"];
    
    NSString *fileContents = [NSString stringWithContentsOfURL:serverURLPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileCoordinates = [fileContents componentsSeparatedByString:@","];
    
    // Convert file coordinates to CLLocationCoordinate2D
    CLLocationCoordinate2D shuttleCoordinates = CLLocationCoordinate2DMake([[fileCoordinates objectAtIndex:0] floatValue], [[fileCoordinates objectAtIndex:1] floatValue]);
    
    // TEMPORARY COORDINATES
    shuttleCoordinates = CLLocationCoordinate2DMake(36.129181, -80.258384);
    
    return shuttleCoordinates;
    
}

// Load shuttle stop markers based on the route id
- (void) loadShuttleStopMarkers
{
    
    // Load file that contains coordinates of shuttle stops
    NSString *path = [[NSBundle mainBundle] pathForResource:@"downtownStops" ofType:@"csv"];
    
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
    NSString* path = [[NSBundle mainBundle] pathForResource:@"downtownRoute" ofType:@"csv"];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    // Array of coordinates for route
    CLLocationCoordinate2D routeCoordinates[[fileLines count]];
    
    // Loop through csv file and get coordinates
    for (int i = 0; i < [fileLines count]; i++)
    {
        NSArray *lineItem = [fileLines[i] componentsSeparatedByString:@","];

        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([[lineItem objectAtIndex:0] floatValue], [[lineItem objectAtIndex:1] floatValue]);
        
        routeCoordinates[i] = coordinates;
        
    }
    
    // Create polyline
    
}

@end