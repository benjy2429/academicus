//
//  LocationSearchTableViewController.m
//  academicus
//
//  Created by Ben on 17/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "LocationSearchTableViewController.h"

@implementation LocationSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialise the geocoder
    self.geocoder = [[CLGeocoder alloc] init];
    
    // If a location already exists, display it in the table
    // Otherwise, initialise an empty array
    self.locations = (self.currentLocation != nil) ? [[NSArray alloc] initWithObjects:self.currentLocation, nil] : [[NSArray alloc] init];
    
    // Override the height of the table view header
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 44);
}


// Perform forward geocoding with the query string to get a list of locations
- (void)forwardGeocode:(NSString *)query {
    [self.geocoder geocodeAddressString:query completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            self.locations = placemarks;
            [self.tableView reloadData];
            
        }
    }];
}


// Called when the cancel navigation bar button is pressed
- (IBAction)cancel {
    [self.delegate locationSearchTableViewControllerDidCancel:self];
}


// Called when the remove navigation bar button is pressed
- (IBAction)removeLocation {
    [self.delegate locationSearchTableViewControllerDidRemoveLocation:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.locations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Assign the correct identifier for this cell
    NSString *myIdentifier = @"locationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myIdentifier];
    }
    
    // Add a detail button to the cell
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    // Get the placemark location for the row
    CLPlacemark *placemark = [self.locations objectAtIndex:indexPath.row];
    
    // Set the labels to display the location data
    cell.textLabel.text = placemark.name;
    cell.detailTextLabel.text = [placemark fullAddress];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // When a row is pressed, call the delegate method to dismiss the view
    [self.delegate locationSearchTableViewController:self didSelectLocation:[self.locations objectAtIndex:indexPath.row]];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // When the detail accessory button is pressed, segue to the map view
    [self performSegueWithIdentifier:@"showMap" sender:[self.locations objectAtIndex:indexPath.row]];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMap"]) {
        MapViewController *controller = (MapViewController*) segue.destinationViewController;
        controller.location = sender;
    }
}


#pragma mark - UISearchBarDelegate

// Called everytime the text changes in the search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // Cancel the current geocoding to prevent conflicting results
    [self.geocoder cancelGeocode];
    
    // Start a new geocode with the new search text
    [self forwardGeocode:searchText];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // When the user scrolls down, keep the segmented control at the top of the screen under the navigation bar using a transform
    // Otherwise, scroll up as normal
    CGFloat offsetY = scrollView.contentOffset.y + 64.0f;
    UIView *headerView = [self.tableView viewWithTag:500];
    headerView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY,0));
}


@end

