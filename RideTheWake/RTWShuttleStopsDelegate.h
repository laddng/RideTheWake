//
//  RTWShuttleStopsDelegate.h
//  RideTheWake
//
//  Created by Nick Ladd on 9/1/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTWAppDelegate.h"

@interface RTWShuttleStopsDelegate : NSObject <NSXMLParserDelegate> {
    
    RTWAppDelegate *appDelegate;
    
}

@property NSMutableArray *stops;

- (RTWShuttleStopsDelegate*) initXmlParser;

@end
