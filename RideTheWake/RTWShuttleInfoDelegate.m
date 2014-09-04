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
        
        NSDate *now = [NSDate date];

        NSDateFormatter *dayOfWeek = [[NSDateFormatter alloc] init];
        
        [dayOfWeek setDateFormat:@"eee kk:mm:ss z"];
        
        [dayOfWeek setDefaultDate:now];
        
        [dayOfWeek setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];

        route.dayShuttleStarts = [dayOfWeek dateFromString:[NSString stringWithFormat:@"%@ 01:00:00 EDT", [attributeDict valueForKey:@"dayShuttleStarts"]]];
        
        route.dayShuttleEnds = [dayOfWeek dateFromString:[NSString stringWithFormat:@"%@ 23:59:59 EDT", [attributeDict valueForKey:@"dayShuttleEnds"]]];
        
        if ([route.dayShuttleStarts compare:route.dayShuttleEnds] == NSOrderedDescending)
        {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:route.dayShuttleEnds];
            NSInteger theDay = [todayComponents day];
            NSInteger theMonth = [todayComponents month];
            NSInteger theYear = [todayComponents year];
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:theDay];
            [components setMonth:theMonth];
            [components setYear:theYear];
            NSDate *thisDate = [gregorian dateFromComponents:components];
            
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:7];
            route.dayShuttleEnds = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];

        }
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        
        [timeFormat setDateFormat:@"kk:mm:ss z"];
        
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
