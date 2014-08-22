//
//  RTWrouteInformation.h
//  RideTheWake
//
//  Created by Nick Ladd on 8/4/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTWrouteInformation : NSObject

@property NSString *routeName;

@property NSString *routeID;

@property NSString *routeStops;

@property NSString *routeClass;

@property int zoomLevel;

@property float centerPointLatitude;

@property float centerPointLongitude;

@end
