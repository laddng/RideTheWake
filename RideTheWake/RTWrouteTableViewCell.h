//
//  RTWrouteTableViewCell.h
//  RideTheWake
//
//  Created by Nick Ladd on 7/29/14.
//  Copyright (c) 2014 Nick Ladd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTWrouteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *routeName;

@property (weak, nonatomic) IBOutlet UIImageView *routeIcon;

@property (weak, nonatomic) IBOutlet UITextView *routeStops;

@end