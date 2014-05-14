//
//  CreateLocationVC.m
//  MoneyMemos
//
//  Created by Student on 5/8/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "CreateLocationVC.h"
#import "MasterViewController.h"

@interface CreateLocationVC ()
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UIButton *createLocation;
@property (strong, nonatomic) UIAlertView *alert;

@end

@implementation CreateLocationVC

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
    
    self.masterViewController = (MasterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"masterController"];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)returnToPrevious{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancel:(id)sender {
    [self returnToPrevious];
}

- (IBAction)createLocation:(id)sender {
    //check to make sure that something is in the location textfield
    if ([self.locationField.text isEqualToString:@""]) {
        NSString *message = @("Please enter a location title");
        
        self.alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:message
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"Ok", nil];
        
        [self.alert show];
    }
    else{
        /***********    ZIP CODE VALIDATION  ************/
        //check the zip textfield value
        int zipValue = -1;
        BOOL foundInvalidCharacter = NO;   // set in the loop if there is an invalid char
        if ([self.zip intValue]) {
            //check and see if our zip is 5 digits long
            if (self.zip.length == 5) {
                zipValue = [self.zip intValue];
                NSUInteger length = self.zip.length; // number of characters
                //check to see if our zip is a valid 5 digit no letters no decimals entry
                NSRegularExpression *regex = [[NSRegularExpression alloc]
                                               initWithPattern:@"[a-zA-Z]" options:0 error:NULL];
                NSUInteger matches = [regex numberOfMatchesInString:self.zip options:0
                                                              range:NSMakeRange(0, [self.zip length])];
                if (matches > 0) {
                    // zip contains at least one English letter.
                    NSLog(@"ERROR - FOUND A LETTER IN THE ZIP ENTRY");
                    foundInvalidCharacter = YES;
                    zipValue = -1;
                }
                //check to see if there are any other invalid characters in the zip string
                for(NSUInteger i = 0; i < length; i++)
                {
                    unichar nextChar = [self.zip characterAtIndex:i]; // get the next character
                    switch (nextChar)
                    {
                        // list of invalid characters
                        case '.':
                            NSLog(@"ERROR - FOUND A DECIMAL IN THE ZIP ENTRY");
                            foundInvalidCharacter = YES;
                            zipValue = -1;
                            break;
                        //character is valid
                        default:
                            break;
                    }
                }
                if (foundInvalidCharacter) {
                    [self showZipAlert];
                }
                else{
                    NSLog(@"%d", zipValue);
                    NSString *s = [NSString stringWithFormat:@"%d", zipValue];
                    if (s.length != 5) {
                        NSLog(@"ZIP CODE ERROR AFTER CONVERTION");
                        foundInvalidCharacter = YES;
                    }
                }
            }
            //alert user if zip is less than or greater than 5 digits long
            else{
                [self showZipAlert];
                foundInvalidCharacter = YES;
                NSLog(@"ZIP IS CONTAINS MORE THAN 5 DIGITS");
            }
            
        }
        else if(![self.zipField.text isEqualToString:@""])
        {
            [self showZipAlert];
            foundInvalidCharacter = YES;
            NSLog(@"ZIP FIELD CONTAINS AN ERROR");
        }
        NSString *zipCode = [NSString stringWithFormat:@"%d", zipValue];
        /***********    END ZIP CODE VALIDATION  ************/
        
        if (!foundInvalidCharacter) {
            //notify our parent about the location creation
            [self notifyLocationCreation:self.location :zipCode];
            NSLog(@"Created my Location");
            [self returnToPrevious];
        }
        
    }
    
    
}

-(void) notifyLocationCreation:(NSString *)theLocation : (NSString *)theZip{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //create a dictionary using literals syntax
    NSDictionary *dict = @{
                           @"name": theLocation,
                           @"zip": theZip,
                           };
    
    // "publish" notification
    NSLog(@"SENT A NOTIFICATION");
    [notificationCenter postNotificationName:kNotificationCreatedLocation object:self userInfo:dict];
    
}

#pragma mark - Text Field Protocols
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.location = self.locationField.text;
    self.zip = self.zipField.text;
    [self.locationField resignFirstResponder];
    [self.zipField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate and alert messages
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)showZipAlert{
    NSString *message = @("Please enter a valid zipcode if US tax rate application is desired.");
    
    self.alert = [[UIAlertView alloc]
                  initWithTitle:@"Error"
                  message:message
                  delegate:self
                  cancelButtonTitle:nil
                  otherButtonTitles:@"Ok", nil];
    
    [self.alert show];
}



@end
