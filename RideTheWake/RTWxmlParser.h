//
//  RTWxmlParser.h
//  RideTheWake
//
//  Created by Nick Ladd on 8/29/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTWAppDelegate;

@interface RTWxmlParser : NSObject<NSXMLParserDelegate>{
    
    float shuttleLocationLat;
    float shuttleLocationLong;
    
    RTWAppDelegate *appdelegate;
    
}

@property float shuttleLocationLat;

@property float shuttleLocationLong;

- (RTWxmlParser*) initXMLParser;

@end
