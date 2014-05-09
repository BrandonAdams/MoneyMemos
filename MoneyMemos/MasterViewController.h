//
//  MasterViewController.h
//  MoneyMemos
//
//  Created by Student on 5/8/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addLocation;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editLocation;
@property (strong, nonatomic) NSMutableArray *listOfLocations;

@end
