//
//  MasterViewController.m
//  MoneyMemos
//
//  Created by Student on 5/8/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "MasterViewController.h"
#import "Location.h"
#import "DetailViewController.h"
#import "CreateLocationVC.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    Location *_loc;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    //loading our saved locations here or creating an empty one
    NSArray *plist = [NSArray arrayWithContentsOfFile:[self docPath]];
    if (plist) {
        // If there was a dataset available, copy it into our instance variable.
        
        _listOfLocations = [plist mutableCopy];
    } else {
        // Otherwise, just create an empty one to get us started.
        _listOfLocations = [[NSMutableArray alloc] init];
    }
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //register for kNotificationGameDidEnd and notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationLocationCreation:) name:kNotificationCreatedLocation object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 Create a new location list 
 **/
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
}
- (IBAction)insertNewLocation:(id)sender {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Notifications
- (void) handleNotificationLocationCreation:(NSNotification *)notification
{
    NSLog(@"MASTER RECIEVED A NOTIFICATION");
    //get the information that was sent by the notification
    NSDictionary *userInfo = notification.userInfo;
    //create a location object and intialize it with our passed in dictionary
    _loc = [[Location alloc] initWithDictionary:userInfo];
    //insert our object into our array of locations and put it into the tableview for the user to see
    [_listOfLocations addObject:_loc];
    [self updateSharedStore];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)updateSharedStore{
    [DataStore sharedStore].allItems = _listOfLocations;
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataStore sharedStore].allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //NSDate *object = _objects[indexPath.row];
    //cell.textLabel.text = [object description];
    
    Location *tempLoc = [DataStore sharedStore].allItems[indexPath.row];
    NSLog(@"Location  name is %@", tempLoc.name);
    cell.textLabel.text = [tempLoc name];
   
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_listOfLocations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateSharedStore];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *selectedLocation = [_listOfLocations objectAtIndex:fromIndexPath.row];
    [_listOfLocations removeObject: selectedLocation];
    [_listOfLocations insertObject:selectedLocation atIndex:toIndexPath.row];
    [self updateSharedStore];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Helper methods
// Helper function to fetch the path to our to-do data stored on disk
- (NSString*) docPath{
    //NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //return [[pathList objectAtIndex:0] stringByAppendingPathComponent:@"money-memos-data.plist"];
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath],@"money-memos-data.plist"];
    return path;
}

// array - writeToFile saves a
- (void)saveTasks{
    if ([DataStore sharedStore].allItems) {
        [[DataStore sharedStore].allItems writeToFile: [self docPath] atomically:YES];
        
    }
    //[[DataStore sharedStore].allItems writeToFile: [self docPath] atomically:YES];
}

@end
