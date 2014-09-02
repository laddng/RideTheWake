//
//  RTWShuttleCoordinatesDelegate.m
//  RideTheWake
//
//  Created by Nick Ladd on 9/1/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWShuttleCoordinatesDelegate.h"

@implementation RTWShuttleCoordinatesDelegate

- (RTWShuttleCoordinatesDelegate*) initXMLParser
{
    
    self = [super init];
    
    appdelegate = (RTWAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict
{
    
    if([elementName isEqualToString:@"marker"])
    {
        
        _shuttleLocationLat = [[attributeDict valueForKey:@"lat"] floatValue];
        
        _shuttleLocationLong = [[attributeDict valueForKey:@"lng"] floatValue];
        
    }
    
}

@end
