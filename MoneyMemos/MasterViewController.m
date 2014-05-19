//
//  MasterViewController.m
//  MoneyMemos
//
//  Created by Student on 5/8/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CreateLocationVC.h"
#import "CreateEntryVC.h"
#import "TaxInformation.h"
#import "Entry.h"

NSString * ZIP_TAX_URL = @"http://api.zip-tax.com/request/v20?key=";
NSString * ZIP_TAX_API_KEY = @"UD7FAV2";


@interface MasterViewController () {
    NSMutableArray *_data;
    NSURLSession *_session;
    Location *_loc;
    BOOL _validZip;
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
    //self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
     self.detailViewController = (DetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detailController"];
    
    
    
    //register for kNotificationGameDidEnd and notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationLocationCreation:) name:kNotificationCreatedLocation object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationEntryCreation:) name:kNotificationCreatedEntry object:nil];
 
    
    
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
    
    
}

- (IBAction)insertNewLocation:(id)sender {
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
    [self loadData:[NSString stringWithFormat:@"%d",_loc.zip]];
    
    //insert our object into our array of locations and put it into the tableview for the user to see
    [_listOfLocations addObject:_loc];
    [self updateSharedStore];
}
/*
- (void) handleNotificationEntryCreation:(NSNotification *)notification
{
    NSLog(@"MASTER RECIEVED AN ENTRY NOTIFICATION");
    //get the information that was sent by the notification
    NSDictionary *userInfo = notification.userInfo;
    
    Entry *entry = [[Entry alloc] initWithDictionary:userInfo];
    
    [_currentLocation.entries addObject:entry];
    
    [self updateSharedStore];
}*/


-(void)updateSharedStore{
    [DataStore sharedStore].allItems = _listOfLocations;
    [self.tableView reloadData];
}

-(void)setLocationSalesTax{
    if (_validZip) {
        TaxInformation *ti = _data[0];
        _loc.tax = ti.taxSales;
        NSLog(@"SALES TAX IS: %f", _loc.tax);
    }
    else{
        _loc.zip = -1;
        NSLog(@"NO TAX IMPLEMENTED");
    }
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
    Location *tempLoc = [DataStore sharedStore].allItems[indexPath.row];
    NSLog(@"Location  name is %@", tempLoc.name);
    //cell.textLabel.text = [tempLoc name];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %lu", [tempLoc name], (unsigned long)tempLoc.entries.count];
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
    Location *tempLoc = [DataStore sharedStore].allItems[indexPath.row];
    self.detailViewController.locationName.text = tempLoc.name;
    
    //CHEAP BEAUTIFUL WAY
    [DataStore sharedStore].currentLocation = _currentLocation;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //Location *selectedLocation = [[DataStore sharedStore].allItems objectAtIndex:indexPath.row];
        _currentLocation = [[DataStore sharedStore].allItems objectAtIndex:indexPath.row];
        
        //self.detailViewController.currentLocation = [[DataStore sharedStore].allItems objectAtIndex:indexPath.row];
        //self.detailViewController.currentLocation = selectedLocation;
        //NSLog(@"showDetail at indexPath.row: %ld", (long)indexPath.row);
        //NSLog(@"self.detailViewController.currentLocation: %@", self.detailViewController.currentLocation);
        //NSLog(@"selectedLocation: %@", selectedLocation);
        //NSLog(@"[[DataStore sharedStore].allItems objectAtIndex:indexPath.row]: %@", [[DataStore sharedStore].allItems objectAtIndex:indexPath.row]);
        //[indexPath];
    }
}

#pragma mark - Helper methods
// Helper function to fetch the path to our to-do data stored on disk
- (NSString*) docPath{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathList objectAtIndex:0] stringByAppendingPathComponent:@"money-memos-data.plist"];
    //NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath],@"money-memos-data.plist"];
    //return path;
}

// array - writeToFile saves a
- (void)saveTasks{
    if ([DataStore sharedStore].allItems) {
        [[DataStore sharedStore].allItems writeToFile: [self docPath] atomically:YES];
        
    }
    //[[DataStore sharedStore].allItems writeToFile: [self docPath] atomically:YES];
}

- (void)loadData:(NSString *)zipcode
{
    
    // 1 - NSURLSession is a class used to download data via HTTP
    
    // 2 - ephemeralSessionConfiguration means
    // we don't need to cache anything
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    // 3 - create a new NSURLSession
    _session = [NSURLSession sessionWithConfiguration:config];
    
    // 4- show the activity indicator in upper-left of screen
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSMutableString *searchString = [NSMutableString string];
    [searchString appendString: ZIP_TAX_URL];
    [searchString appendString:ZIP_TAX_API_KEY];
    [searchString appendString:@"&postalcode="];
    [searchString appendString:zipcode];
    
    NSLog(@"Searching for %@", searchString);
    
    NSURL *url = [NSURL URLWithString:searchString];
    
    // 6 - this is a data task where we request a resource
    NSURLSessionDataTask *dataTask =
    [_session dataTaskWithURL:url
     
     // begin completion handler - this is called when we get the data
     // Gah!
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                if (!error) {
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                    // 7 - HTTP status code 200 is OK
                    if (httpResp.statusCode == 200) {
                        
                        NSError *jsonError;
                        // 8 - convert loaded string to JSON
                        NSDictionary *json =
                        [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableLeaves
                                                          error:&jsonError];
                        
                        if (!jsonError) {
                            // 9 - finally start parsing - get array of concerts (dictionaries)
                            /*****  CHECK FOR CORRECT rCode SIGNATURE HERE  *******/
                            int rCode = [json[@"rCode"]intValue];
                            NSLog(@"rCode = %d",rCode);
                            if (rCode == 100)
                            {
                                _validZip = YES;
                                NSArray *zipTaxResponse = json[@"results"];
                                NSMutableArray *tempArray = [NSMutableArray array];
                                
                                // 10 - loop through dictionaries and create Concert objects
                                for (NSDictionary *d in zipTaxResponse) {
                                    TaxInformation *ti = [[TaxInformation alloc] initWithDictionary:d];
                                    [tempArray addObject: ti];
                                }
                                _data = tempArray;
                                if (_data.count == 0) {
                                    _validZip = NO;
                                }
                            }
                            else{
                                _validZip = NO;
                            }
                            [self setLocationSalesTax];
                        } // end if (!jsonError)
                    } // end if (httpResp.statusCode == 200)
                } // end if (!error)
            } // end completion handler
     ]; // end method call
    
    
    // 12 - starts (or resumes) the data task
    [dataTask resume];
    
    
}

@end
