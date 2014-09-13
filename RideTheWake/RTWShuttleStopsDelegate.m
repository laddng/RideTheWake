//
//  RTWShuttleStopsDelegate.m
//  RideTheWake
//
//  Created by Nick Ladd on 9/1/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWShuttleStopsDelegate.h"
#import "RTWShuttleStop.h"

@implementation RTWShuttleStopsDelegate

-(RTWShuttleStopsDelegate*) initXmlParser
{
    
    self = [super init];
    
    appDelegate = (RTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _stops = [[NSMutableArray alloc] init];
    
    return self;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    if([elementName isEqualToString:@"stop"])
    {
        
        RTWShuttleStop *stop = [[RTWShuttleStop alloc] init];
        
        stop.stopName = [attributeDict objectForKey:@"name"];
        
        stop.stopCoordinatesLat = [[attributeDict objectForKey:@"coordinateLat"] floatValue];
        
        stop.stopCoordinatesLon = [[attributeDict objectForKey:@"coordinateLon"] floatValue];
        
        stop.stopTimes = [attributeDict objectForKey:@"times"];
     
        [_stops addObject:stop];
        
    }
    
    if([elementName isEqualToString:@"stopInformation"])
    {
        
        [_stops addObject:[attributeDict objectForKey:@"info"]];
        
    }
    
}

@end