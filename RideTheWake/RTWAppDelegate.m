//
//  RTWAppDelegate.m
//  RideTheWake
//
//  Created by Nick Ladd on 7/24/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import "RTWAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation RTWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyA0g2Dhwmn_rjrurdG1DnsHtCWCEoQpAis"];

    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    
    [GAI sharedInstance].dispatchInterval = 20;
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-53602812-1"];
    
    return YES;
}

@end
