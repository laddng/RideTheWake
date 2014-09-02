//
//  RTWmapViewController.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/24/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWmapViewController.h"
#import "RTWscheduleTableViewController.h"
#import "RTWShuttleCoordinatesDelegate.h"
#import "RTWShuttleStopsDelegate.h"
#import "RTWShuttleStop.h"

@interface RTWmapViewController ()

@property (strong, nonatomic) GMSMarker *shuttleMarker;

@property (strong, nonatomic) NSMutableArray *stops;

@end

@implementation RTWmapViewController

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Map Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    _shuttleMarker = [[GMSMarker alloc] init];
    _shuttleMarker.map = self.mapView;
    _shuttleMarker.icon = [UIImage imageNamed:@"shuttleMarker"];
    _shuttleMarker.zIndex = 1000;
    
    [self loadShuttlesCurrentLocation:nil];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:218/255.0 green:174/255.0 blue:77/255.0 alpha:1];
    
    self.navigationItem.title = _routeInfo.routeName;

    _stops = [[NSMutableArray alloc] init];
    
    [self loadMapView];
    
    [self loadShuttleStopMarkers];
    
    [self loadRoutePath];
    

}

- (void) loadMapView
{
    
    GMSCameraPosition *shuttle = [GMSCameraPosition cameraWithLatitude:_routeInfo.centerPointLatitude longitude:_routeInfo.centerPointLongitude zoom:_routeInfo.zoomLevel];
        
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
    
    NSURL *serverURLPath = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://shuttle.cs.wfu.edu/%@.xml", _routeInfo.xmlFile]];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfURL:serverURLPath]];
    
    RTWShuttleCoordinatesDelegate *theDelegate = [[RTWShuttleCoordinatesDelegate alloc] initXMLParser];
    
    [parser setDelegate:theDelegate];
    
    [parser parse];

    CLLocationCoordinate2D shuttleCoordinates = CLLocationCoordinate2DMake(theDelegate.shuttleLocationLat, theDelegate.shuttleLocationLong);
 
    _shuttleMarker.position = shuttleCoordinates;
    
    [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(loadShuttlesCurrentLocation:) userInfo:nil repeats:YES];

}

- (void) loadShuttleStopMarkers
{
    
    NSString *pathToStopsFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Stops", _routeInfo.routeID] ofType:@"xml"];
    
    NSXMLParser *fileParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:pathToStopsFile]];
    
    RTWShuttleStopsDelegate *fileParserDelegate = [[RTWShuttleStopsDelegate alloc] initXmlParser];
    
    [fileParser setDelegate:fileParserDelegate];
    
    [fileParser parse];
    
    _stops = fileParserDelegate.stops;
    
    for (int i = 0; i<[_stops count]-1; i++)
    {
    
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        RTWShuttleStop *stop = [[RTWShuttleStop alloc] init];
        
        stop = [_stops objectAtIndex:i];
        
        marker.position = CLLocationCoordinate2DMake(stop.stopCoordinatesLat, stop.stopCoordinatesLon);
        marker.snippet = [[_stops objectAtIndex:i] stopName];
        marker.map = self.mapView;
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        
    }
    
}

- (void) loadRoutePath
{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@Route", _routeInfo.routeID] ofType:@"csv"];
    
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
        
        scheduleVC.routeID = _routeInfo.routeName;
        scheduleVC.routeIDName = _routeInfo.routeID;
        
    }
    
}

- (IBAction)viewDidUnwind:(UIStoryboardSegue *)segue
{
    
}

@end