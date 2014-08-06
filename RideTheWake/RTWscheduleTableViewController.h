//
//  RTWscheduleTableViewController.h
//  RideTheWake
//
//  Created by Nick Ladd on 7/29/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTWscheduleTableViewController : UITableViewController

@property (weak, nonatomic) NSString *routeID;

@property NSString *routeIDName;

@property (weak, nonatomic) IBOutlet UITextView *scheduleInformation;

@end
