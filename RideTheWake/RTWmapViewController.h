//
//  RTWmapViewController.h
//  RideTheWake
//
//  Created by Nick Ladd on 7/24/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface RTWmapViewController : UIViewController<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end