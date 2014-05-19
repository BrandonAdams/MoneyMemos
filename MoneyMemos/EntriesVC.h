//
//  EntriesVC.h
//  MoneyMemos
//
//  Created by Student on 5/18/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"



@interface EntriesVC : UITableViewController

@property (strong, nonatomic) UIViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *listOfEntries;

@end
