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
    
    /*
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Map Screen"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    */
    
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
    
    [self shuttleIsOfflineWarning];
    
    [self loadMapView];
    
    [self loadRoutePath];
    
    [self loadShuttleStopMarkers];

}

- (void) shuttleIsOfflineWarning
{
    
    NSDate *currentTime = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"kk:mm:ss z"];
    
    [formatter setDefaultDate:currentTime];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EDT"]];
    
    NSDate *midnightNight = [formatter dateFromString:@"23:59:59 EDT"];
    
    NSDate *midnightMorning = [formatter dateFromString:@"00:00:00 EDT"];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    
    [dayFormatter setDateFormat:@"eeee"];
    
    [dayFormatter setDefaultDate:currentTime];
    
    [dayFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    
    NSString *dayStartString = [dayFormatter stringFromDate: _routeInfo.dayShuttleStarts];
    
    NSString *dayEndString = [dayFormatter stringFromDate:_routeInfo.dayShuttleEnds];
    
    NSString *startTimeString = [self printEasternTime:_routeInfo.timeShuttleStarts];
    
    NSString *endTimeString = [self printEasternTime:_routeInfo.timeShuttleEnds];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    
    dayComponent.day = 2;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    
    NSDate *endDayPlusOne = [theCalendar dateByAddingComponents:dayComponent toDate:_routeInfo.dayShuttleEnds options:0];
    
    if (([_routeInfo.routeClass isEqualToString:@"night"]&&(((([currentTime compare:_routeInfo.timeShuttleStarts] == NSOrderedDescending) && ([currentTime compare:midnightNight] == NSOrderedAscending))|| (([currentTime compare:midnightMorning] == NSOrderedDescending) && ([currentTime compare:_routeInfo.timeShuttleEnds] == NSOrderedAscending)))&& ((([currentTime compare:_routeInfo.dayShuttleStarts] == NSOrderedDescending) && ([currentTime compare:_routeInfo.dayShuttleEnds] == NSOrderedAscending)))))|| ([_routeInfo.routeClass isEqualToString:@"night"]&& (([currentTime compare:midnightMorning] == NSOrderedDescending) && ([currentTime compare:_routeInfo.timeShuttleEnds] == NSOrderedAscending)) && (([currentTime compare:_routeInfo.dayShuttleStarts] == NSOrderedDescending) && ([currentTime compare:endDayPlusOne] == NSOrderedAscending))))
    {}
    
    else if ([_routeInfo.routeClass isEqualToString:@"day"]&& ((([currentTime compare:_routeInfo.timeShuttleStarts] == NSOrderedDescending) && ([currentTime compare:_routeInfo.timeShuttleEnds] == NSOrderedAscending)))&& ((([currentTime compare:_routeInfo.dayShuttleStarts] == NSOrderedDescending) && ([currentTime compare:_routeInfo.dayShuttleEnds] == NSOrderedAscending))))
    {}
    
    else {
        
        UIAlertView *shuttleIsOfflineAlert = [[UIAlertView alloc] initWithTitle:@"Shuttle is offline" message:[NSString stringWithFormat:@"The %@ shuttle is not operating at this time. It runs from %@ to %@, %@ thru %@.", _routeInfo.routeName, startTimeString, endTimeString, dayStartString, dayEndString] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        
        [shuttleIsOfflineAlert show];
        
    }
    
}

- (NSString *) printEasternTime:(NSDate*)date
{
    
    NSDateFormatter *estTimeZone = [[NSDateFormatter alloc] init];
    
    [estTimeZone setDateFormat:@"h:mm a"];
    
    [estTimeZone setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EDT"]];
    
    NSString *string = [estTimeZone stringFromDate:date];
    
    return string;
    
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
    
    NSURL *serverURLPath = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://152.17.49.23/%@.xml", _routeInfo.xmlFile]];
    
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
    
    NSURL *pathToStopsFile = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://152.17.49.23/%@Stops.xml", _routeInfo.xmlFile]];
    
    NSXMLParser *fileParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfURL:pathToStopsFile]];
    
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

    NSURL *path = [NSURL URLWithString:[NSString stringWithFormat:@"http://152.17.49.23/%@Route.csv", _routeInfo.routeID]];
    
    NSString* fileContents = [NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:NULL];
    
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
        scheduleVC.stops = _stops;
        
    }
    
}

- (IBAction)viewDidUnwind:(UIStoryboardSegue *)segue
{
    
}

@end