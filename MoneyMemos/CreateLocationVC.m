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

-(void)returnToLocations{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancel:(id)sender {
    [self returnToLocations];
}

- (IBAction)createLocation:(id)sender {
    [self returnToLocations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.location = self.locationField.text;
    self.zip = self.zipField.text;
    NSLog(@"%@, %@", _zip, _location);
    [self.locationField resignFirstResponder];
    [self.zipField resignFirstResponder];
    return YES;
}

@end
