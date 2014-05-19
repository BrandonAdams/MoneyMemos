//
//  DetailViewController.h
//  MoneyMemos
//
//  Created by Student on 5/8/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

static NSString *kNotificationSetDetailLocation = @"kNotificationSetDetailLocation";

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenses;
@property (weak, nonatomic) IBOutlet UILabel *taxAllocated;
@property (weak, nonatomic) IBOutlet UILabel *expenseTotal;

@property (nonatomic) Location *currentLocation;

-(void)updateTextFields;

@end
