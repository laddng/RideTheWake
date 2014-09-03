//
//  RTWShuttleInfoDelegate.m
//  RideTheWake
//
//  Created by Nick Ladd on 9/1/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWShuttleInfoDelegate.h"
#import "RTWrouteInformation.h"

@implementation RTWShuttleInfoDelegate

- (RTWShuttleInfoDelegate*) initXmlParser
{
    
    self = [super init];
    
    appDelegate = (RTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _dayRoutes = [[NSMutableArray alloc] init];
    
    _nightRoutes = [[NSMutableArray alloc] init];
    
    return self;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    
    if([elementName isEqualToString:@"shuttle"])
    {
        
        RTWrouteInformation *route = [[RTWrouteInformation alloc] init];
        
        route.routeName = [attributeDict valueForKey:@"name"];
        
        route.routeClass = [attributeDict valueForKey:@"category"];
        
        route.routeID = [attributeDict valueForKey:@"id"];
        
        route.routeStops = [attributeDict valueForKey:@"stops"];
        
        route.zoomLevel = [[attributeDict valueForKey:@"mapViewInitialZoomLevel"] intValue];

        route.centerPointLatitude = [[attributeDict valueForKey:@"mapViewCenterCoordinateLat"] floatValue];

        route.centerPointLongitude = [[attributeDict valueForKey:@"mapViewCenterCoordinateLon"] floatValue];

        route.xmlFile = [attributeDict valueForKey:@"serverShuttleURL"];
        
        route.dayShuttleStarts = [attributeDict valueForKey:@"dayShuttleStarts"];
        
        route.dayShuttleEnds = [attributeDict valueForKey:@"dayShuttleEnds"];
        
        NSDate *now = [NSDate date];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        
        [timeFormat setDateFormat:@"k:mm:ss z"];
        
        [timeFormat setDefaultDate:now];
        
        [timeFormat setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
        
        route.timeShuttleEnds = [timeFormat dateFromString:[attributeDict valueForKey:@"timeShuttleEnds"]];
        
        route.timeShuttleStarts = [timeFormat dateFromString:[attributeDict valueForKey:@"timeShuttleStarts"]];
        
        if ([route.routeClass isEqualToString:@"day"])
        {
            
            [_dayRoutes addObject:route];
            
        }
        
        else if ([route.routeClass isEqualToString:@"night"])
        {
            
            [_nightRoutes addObject:route];
            
        }
        
    }
    
}

@end
