//
//  PersonalTableViewController.m
//  academicus
//
//  Created by Luke on 06/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "PersonalTableViewController.h"

@implementation PersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Load previously entered data
    self.nameField.text = self.itemToEdit.name;
    self.addressLocation = self.itemToEdit.address;
    [self configureAddressCell];
    self.telephoneField.text = self.itemToEdit.phone;
    self.emailField.text = self.itemToEdit.email;
    self.websiteField.text = self.itemToEdit.website;
    self.originalPhoto = [UIImage imageWithData: self.itemToEdit.photo]; //Read in a uiimage from the stored data
    [self displayPhoto]; //Display the selected photo
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Open the keyboard automatically when the view appears
    [self.nameField becomeFirstResponder];
}


- (BOOL) isEnteredDataValid {
    //Check that the name length is less than 30
    if ([self.nameField.text length] > 30) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The name must be less than 30 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the phone length is less than 15
    if ([self.telephoneField.text length] > 15) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The telephone number must be less than 15 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the email length is less than 50
    if ([self.emailField.text length] > 50) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The email must be less than 50 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    //Check that the website length is less than 50
    if ([self.websiteField.text length] > 50) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Whoops!" message: @"The website must be less than 50 characters" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    return true;
}


//When the save button is pressed
- (IBAction)done {
    // Validate the input data
    if (![self isEnteredDataValid]) {return;}
    
    self.itemToEdit.photo = UIImagePNGRepresentation(self.originalPhoto); //Convert the photo to nsdata for core data storage
    self.itemToEdit.name = self.nameField.text;
    self.itemToEdit.address = self.addressLocation;
    self.itemToEdit.phone = self.telephoneField.text;
    self.itemToEdit.email = self.emailField.text;
    self.itemToEdit.website = self.websiteField.text;
    
    [self.delegate personalTableViewController:self didFinishSavingPortfolio:self.itemToEdit];
}


//When the cancel button is pressed
- (IBAction)cancel {
    [self.delegate personalTableViewControllerDidCancel:self];
}


#pragma mark - Photo Selection

//If the user clicks the cancel button on any of the photo pickers, this method dismisses the picker
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//If the picker, returns with an image this method is called
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //We store the selected photo in memory so that it can be saved later. We save the original rather than the cropped to preserve the full image
    self.originalPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    //If the user has enabled automatic saving, and this photo was taken using the camera, the original photo is saved to the camera roll
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoSavePhotos"] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(self.originalPhoto, self, nil, nil);
    }
    //We reload the view to adjust row heights
    [self.tableView reloadData];
    //The photo is then added to the display
    [self displayPhoto];
    //The picker is then hidden
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//This method formats the photo stored in memory to be dislpayed
-(void) displayPhoto {
    //First we determine the orientation of the photo be getting the shortest measurement
    float smallestDimension = fminf(self.originalPhoto.size.width, self.originalPhoto.size.height);
    //We create a square that appears in the center of the photo
    float newOriginX = (self.originalPhoto.size.width - smallestDimension) / 2.0f;
    float newOriginY = (self.originalPhoto.size.height - smallestDimension) / 2.0f;
    BOOL landscapeImage = (self.originalPhoto.imageOrientation != UIImageOrientationLeft && self.originalPhoto.imageOrientation != UIImageOrientationRight);
    CGRect croppedPhotoSize = CGRectMake((landscapeImage ? newOriginX : newOriginY), (landscapeImage ? newOriginY : newOriginX), smallestDimension, smallestDimension);
    //Create a cropped version of the image
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([self.originalPhoto CGImage], croppedPhotoSize);
    UIImage* croppedPhoto = [UIImage imageWithCGImage:croppedImageRef scale:(self.photoView.frame.size.width/self.originalPhoto.size.width) orientation:self.originalPhoto.imageOrientation];
    //Add the cropped image to the view
    [self.photoView setImage:croppedPhoto];
}


#pragma mark - Table View

- (void)configureAddressCell {
    self.addressLabel.text = (self.addressLocation != nil) ? [NSString stringWithFormat:@"%@, %@", self.addressLocation.name, ABCreateStringWithAddressDictionary(self.addressLocation.addressDictionary, NO)] : @"No Location Selected";
}


//When a row is selected
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //The "choose photo" row is the row that has been tapped
    if (indexPath.section == 3 && indexPath.row == 0) {
        //Create a action sheet style alert to provide the user with some options
        UIAlertController* actionSheet =  [UIAlertController alertControllerWithTitle:@"Portfolio Photo" message:@"Select or take a photo for your portfolio" preferredStyle:UIAlertControllerStyleActionSheet ];
        
        //Check to see if a camera is available and add the camera option to the menu if it is
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
            UIAlertAction* newPhotoAction = [UIAlertAction actionWithTitle:@"Take new photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                //If the user clicks this option from the action sheet, create and show the camera picker
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = NO;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
            [actionSheet addAction:newPhotoAction];
        } else {
            //If the camera isnt available as a source display an alert informing the user sp
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Hmm..." message: @"Your camera is unavailable at the moment" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        //Check to see if the photo library is available and add the existing photos option to the menu if it is
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
            UIAlertAction* existingPhotoAction = [UIAlertAction actionWithTitle:@"Select from existing photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                //If the user clicks this option from the action sheet, create and show the photo library picker
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
            [actionSheet addAction:existingPhotoAction];
        } else {
            //If the photo library isnt available as a source display an alert informing the user sp
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Hmm..." message: @"Your photo library is unavailable at the moment" delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        //If a photo has already been picked before, provide the option to remove this photo
        if (self.originalPhoto != nil) {
            UIAlertAction* removePhotoAction = [UIAlertAction actionWithTitle:@"Remove photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                //If the remove option is clicked, remove the photo from the display and from memory
                [self.tableView reloadData];
                [self.photoView setImage:nil];
                self.originalPhoto = nil;
            }];
            [actionSheet addAction:removePhotoAction];
        }
        
        //Add a cancel option to the action sheet which closes the menu if clicked
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){[actionSheet dismissViewControllerAnimated:YES completion:nil];
        }];
        [actionSheet addAction:cancelAction];
        
        //Once all the options have been added, we display the action sheet style alert
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //If the current cell is the photo cell
    if (indexPath.section == 3 && indexPath.row == 0) {
        //If a photo is in memory
        if (self.originalPhoto != nil) {
            //Show this image and hide the cell placeholder and accessory
            self.photoPlaceholder.hidden = YES;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            self.photoView.hidden = NO;
        } else {
            //Hide the image view and show the cell placeholder and accessory
            self.photoView.hidden = YES;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            self.photoPlaceholder.hidden = NO;
        }
    }
}


//Set the height for the cells depending on their position
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0 && self.originalPhoto != nil) {
        return tableView.frame.size.width;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


#pragma mark - LocationSearchTableViewControllerDelegate

- (void)locationSearchTableViewControllerDidCancel:(LocationSearchTableViewController *)controller {
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)locationSearchTableViewController:(LocationSearchTableViewController*)controller didSelectLocation:(CLPlacemark *)location {
    self.addressLocation = location;
    [self configureAddressCell];
    
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationSearchTableViewControllerDidRemoveLocation:(LocationSearchTableViewController*)controller {
    self.addressLocation = nil;
    [self configureAddressCell];
    
    // Dismiss the view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toLocationSearch"]) {
        UINavigationController *navController = segue.destinationViewController;
        LocationSearchTableViewController *controller = (LocationSearchTableViewController*) navController.topViewController;
        controller.delegate = self;
        controller.currentLocation = self.addressLocation;
    }
}


@end

