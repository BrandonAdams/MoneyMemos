//
//  CreateEntryVC.m
//  MoneyMemos
//
//  Created by Student on 5/18/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "CreateEntryVC.h"

@interface CreateEntryVC ()
@property (strong, nonatomic) UIAlertView *alert;

@end

@implementation CreateEntryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)returnToPrevious
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancel:(id)sender
{
    [self returnToPrevious];
}

- (IBAction)createEntry:(id)sender
{
    //check to make sure that something is in the amount textfield
    if ([self.amountField.text isEqualToString:@""])
    {
        [self showAmountAlert];
    }
    else
    {
        /***********    AMOUNT VALIDATION  ************/
        //check the amount textfield value
        float amountValue = -1;
        BOOL foundInvalidCharacter = NO;   // set in the loop if there is an invalid char
        if ([self.amount floatValue])
        {
            amountValue = [self.amount floatValue];
            //check to see if our amount has no letters
            NSRegularExpression *regex = [[NSRegularExpression alloc]
                                          initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
            NSUInteger matches = [regex numberOfMatchesInString:self.amount options:0
                                                          range:NSMakeRange(0, [self.amount length])];
            if (matches > 0)
            {
                // zip contains at least one English letter.
                NSLog(@"ERROR - FOUND A LETTER IN THE AMOUNT");
                foundInvalidCharacter = YES;
                amountValue = -1;
            }
            if (foundInvalidCharacter)
            {
                [self showAmountAlert];
            }
            /*
            else
            {
                NSLog(@"%f", amountValue);
                NSString *s = [NSString stringWithFormat:@"%f", amountValue];
                if (s.length != 5)
                {
                    NSLog(@"ZIP CODE ERROR AFTER CONVERTION");
                    foundInvalidCharacter = YES;
                }
            }
            */
            
        }
        else if(![self.amountField.text isEqualToString:@""])
        {
            [self showAmountAlert];
            foundInvalidCharacter = YES;
            NSLog(@"AMOUNT FIELD CONTAINS AN ERROR");
        }
        NSString *amount = [NSString stringWithFormat:@"%f", amountValue];
        /***********    END AMOUNT VALIDATION  ************/
        
        if (!foundInvalidCharacter)
        {
            //notify our parent about the location creation
            [self notifyEntryCreation: amount];
            [self returnToPrevious];
        }
        
    }
}//createEntry

-(void) notifyEntryCreation:(NSString *)theAmount// : (NSString *)theType
{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //create a dictionary using literals syntax
    NSDictionary *dict = @{
                           @"amount": theAmount,
                           @"type": @"MISC",
                           };
    
    // "publish" notification
    NSLog(@"SENT A NOTIFICATION");
    [notificationCenter postNotificationName:kNotificationCreatedEntry object:self userInfo:dict];
    
}

#pragma mark - Text Field Protocols
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.amount = self.amountField.text;
    //self.type = self.typeField.text;
    [self.amountField resignFirstResponder];
    //[self.zipField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate and alert messages
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)showAmountAlert
{
    NSString *message = @("Please enter a valid amount.");
    
    self.alert = [[UIAlertView alloc]
                  initWithTitle:@"Error"
                  message:message
                  delegate:self
                  cancelButtonTitle:nil
                  otherButtonTitles:@"Ok", nil];
    
    [self.alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
