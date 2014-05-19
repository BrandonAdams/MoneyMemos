//
//  DetailViewController.m
//  MoneyMemos
//
//  Created by Student on 5/8/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "DetailViewController.h"
#import "DataStore.h"
#import "Entry.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
    
    [self updateTextFields];
    
}

- (IBAction)update:(id)sender
{
    [self updateTextFields];
}

-(void)updateTextFields
{
    _currentLocation = [DataStore sharedStore].currentLocation;
    _locationName.text = _currentLocation.name;
    float expensesAmount = 0;
    for (int i = 0; i < _currentLocation.entries.count; i++)
    {
        expensesAmount += ((Entry *)_currentLocation.entries[i]).amount;
    }
    _expenses.text = [NSString stringWithFormat:@"%.2f",expensesAmount];
    float taxAmount = _currentLocation.tax * expensesAmount;
    if (_currentLocation.zip == -1) {
        _taxAllocated.text = @"N/A";
    }
    else{
        _taxAllocated.text = [NSString stringWithFormat:@"%.2f",taxAmount];
    }
    float totalAmount = expensesAmount + taxAmount;
    _expenseTotal.text = [NSString stringWithFormat:@"%.2f",totalAmount];
    
}//updateTextFields

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"DETAIL SEGUE");
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    //self.navigationItem.leftBarButtonItem.action = @selector(butts);
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
