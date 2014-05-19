//
//  CreateEntryVC.h
//  MoneyMemos
//
//  Created by Student on 5/18/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kNotificationCreatedEntry = @"kNotificationCreatedEntry";

@interface CreateEntryVC : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *amountField;
//@property (strong, nonatomic) IBOutlet UITextField *typeField;
@property (nonatomic) NSString *amount;
//@property (strong, nonatomic) NSString *zip;

@end
