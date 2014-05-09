//
//  CreateLocationVC.h
//  MoneyMemos
//
//  Created by Student on 5/8/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController;

@interface CreateLocationVC : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) MasterViewController *masterViewController;

@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UITextField *zipField;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *zip;


@end
