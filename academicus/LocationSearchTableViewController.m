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
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.locations = (self.currentLocation != nil) ? [[NSArray alloc] initWithObjects:self.currentLocation, nil] : [[NSArray alloc] init];
    
    // Override the height of the table view header
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 44);
    
}


- (void)forwardGeocode:(NSString *)query
{
    [self.geocoder geocodeAddressString:query completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            self.locations = placemarks;
            [self.tableView reloadData];
            
        }
    }];
}


- (IBAction)cancel
{
    [self.delegate locationSearchTableViewControllerDidCancel:self];
}


- (IBAction)removeLocation
{
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
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    CLPlacemark *placemark = [self.locations objectAtIndex:indexPath.row];
    
    // Set the content for each type of
    cell.textLabel.text = placemark.name;
    cell.detailTextLabel.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate locationSearchTableViewController:self didSelectLocation:[self.locations objectAtIndex:indexPath.row]];
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showMap" sender:[self.locations objectAtIndex:indexPath.row]];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showMap"]) {
        MapViewController *controller = (MapViewController*) segue.destinationViewController;
        controller.location = sender;
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.geocoder cancelGeocode];
    
    [self forwardGeocode:searchText];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // When the user scrolls down, keep the segmented control at the top of the screen under the navigation bar using a transform
    // Otherwise, scroll up as normal
    CGFloat offsetY = scrollView.contentOffset.y + 64.0f;
    UIView *headerView = [self.tableView viewWithTag:500];
    headerView.transform = CGAffineTransformMakeTranslation(0, MIN(offsetY,0));
}

@end
