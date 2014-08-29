//
//  RTWmapViewController.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/24/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWmapViewController.h"
#import "RTWscheduleTableViewController.h"
#import "RTWxmlParser.h"

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
    
    [self loadShuttlesCurrentLocation:nil];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:218/255.0 green:174/255.0 blue:77/255.0 alpha:1];
    
    self.navigationItem.title = _routeID;

    [self loadMapView];
    
    [self loadShuttleStopMarkers];
    
    [self loadRoutePath];
    

}

- (void) loadMapView
{
    
    GMSCameraPosition *shuttle = [GMSCameraPosition cameraWithLatitude:_centerPointLatitude longitude:_centerPointLongitude zoom:_zoomLevel];
        
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:shuttle];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;

    self.view = self.mapView;

}

- (void) loadShuttlesCurrentLocation:(NSTimer*)timer
{
 
    [timer invalidate];
    
    NSURL *serverURLPath = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://shuttle.cs.wfu.edu/%@.xml", _xmlFile]];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfURL:serverURLPath]];
    
    RTWxmlParser *theDelegate = [[RTWxmlParser alloc] initXMLParser];
    
    [parser setDelegate:theDelegate];
    
    [parser parse];

    CLLocationCoordinate2D shuttleCoordinates = CLLocationCoordinate2DMake(theDelegate.shuttleLocationLat, theDelegate.shuttleLocationLong);
 
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = shuttleCoordinates;
    marker.map = self.mapView;
    marker.icon = [UIImage imageNamed:@"shuttleMarker"];
    marker.zIndex = 1000;
    
    [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(loadShuttlesCurrentLocation:) userInfo:nil repeats:YES];

}

- (void) loadShuttleStopMarkers
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Stops", _routeIDName] ofType:@"csv"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < [fileLines count]-1; i++)
    {

        GMSMarker *marker = [[GMSMarker alloc] init];
        
        NSArray *lineItem = [fileLines[i] componentsSeparatedByString:@","];
        
        marker.position = CLLocationCoordinate2DMake([[lineItem objectAtIndex:0] floatValue], [[lineItem objectAtIndex:1] floatValue]);
        marker.snippet = [lineItem objectAtIndex:2];
        marker.map = self.mapView;
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        
    }

}

- (void) loadRoutePath
{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Route", _routeIDName] ofType:@"csv"];
    
    NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *fileLines = [fileContents componentsSeparatedByString:@"\n"];
    
    GMSMutablePath *polylineCoordinates = [GMSMutablePath path];

    for (int i = 0; i < [fileLines count]; i++)
    {
        NSArray *lineItem = [fileLines[i] componentsSeparatedByString:@","];
        
        [polylineCoordinates addCoordinate:CLLocationCoordinate2DMake([[lineItem objectAtIndex:0] floatValue], [[lineItem objectAtIndex:1] floatValue])];
        
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:polylineCoordinates];
    polyline.map = _mapView;
    polyline.strokeWidth = 8.f;
    polyline.strokeColor = [UIColor colorWithRed:0/255.0 green:179/255.0 blue:253/255.0 alpha:1];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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