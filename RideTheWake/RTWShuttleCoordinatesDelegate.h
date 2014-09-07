//
//  RTWShuttleCoordinatesDelegate.h
//  RideTheWake
//
//  Created by Nick Ladd on 9/1/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTWAppDelegate.h"

@interface RTWShuttleCoordinatesDelegate : NSObject<NSXMLParserDelegate>{
    
    RTWAppDelegate *appdelegate;
    
}

@property float shuttleLocationLat;

@property float shuttleLocationLong;

- (RTWShuttleCoordinatesDelegate*) initXMLParser;

@end
