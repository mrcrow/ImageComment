//
//  ImageManageController.m
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import "ImageManageController.h"
#import "ColorExtention.h"
       
#define BIG_CELL_HEIGHT 200.0

@interface ImageManageController ()
@property (strong, nonatomic)   UITextField     *nameField;
@property (strong, nonatomic)   UILabel         *locationLabel;
@property (strong, nonatomic)   UITextView      *commentView;
@property (strong, nonatomic)   NSData          *imageData;
@property                       BOOL            newMedia;

@property (strong, nonatomic)   UIActionSheet   *imageSelectionSheet;
@property (strong, nonatomic)   UIActionSheet   *cancelActionSheet;
@end

@implementation ImageManageController
@synthesize managedObjectContext = _managedObjectContext, locationController = _locationController;
@synthesize nameField = _nameField, locationLabel = _locationLabel, commentView = _commentView;
@synthesize content = _content;
@synthesize newMedia, previewMode;
@synthesize imageSelectionSheet = _imageSelectionSheet, cancelActionSheet = _cancelActionSheet;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Image Content", @"Image and attributes");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setLocationController:nil];
    [self setImageController:nil];
    [self setManagedObjectContext:nil];
    [self setNameField:nil];
    [self setLocationLabel:nil];
    [self setCommentView:nil];
    [self setImageSelectionSheet:nil];
    [self setCancelActionSheet:nil];
    [self setContent:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button functions

- (void)initialzeViewButtons
{
    if (previewMode)
    {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    else
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        self.navigationItem.rightBarButtonItem = doneButton;
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

- (void)cancel
{
    if (!self.cancelActionSheet)
    {
        _cancelActionSheet = [[UIActionSheet alloc] initWithTitle:@"The record will not be saved" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    }
    [_cancelActionSheet showInView:self.view];
}

- (void)done
{
    if ([_nameField.text length] != 0)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The name of the photo is need" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(imageSelection)];
        self.navigationItem.leftBarButtonItem = cameraButton;
    }
    else
    {
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)imageSelection
{
    if (!self.imageSelectionSheet)
    {
        _imageSelectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select from Photo Album", @"Take a photo", nil];
    }
    [_imageSelectionSheet showInView:self.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *counts = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:1],      //Name
                       [NSNumber numberWithInt:1],      //Image
                       [NSNumber numberWithInt:1],      //Location
                       [NSNumber numberWithInt:1],      //Comment
                       nil];
    return [[counts objectAtIndex:section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    switch (section)
    {
        case 0: return [self cellForImageName];
        case 1: return [self cellForImageView];
        case 2: return [self cellForImageLocation];
        case 3: return [self cellForImageComment];
        default: return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) //Image
    {
        if ([_content.hasImage boolValue])
        {
            return BIG_CELL_HEIGHT;
        }
    }
    
    if (indexPath.section == 3) //Comment
    {
        return BIG_CELL_HEIGHT;
    }
    
    return [self.tableView rowHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if ([_content.hasImage boolValue])
        {
            //preview image
            
        }
        else
        {
            //camera or image roll
            if (!self.imageSelectionSheet)
            {
                _imageSelectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select from Photo Album", @"Take a photo", nil];
            }
            
            [_imageSelectionSheet showInView:self.view];
        }
    }
    
    if (indexPath.section == 2)
    {
        //push location view 
        if (!self.locationController)
        {
            self.locationController = [[ImageLocationController alloc] initWithNibName:@"ImageLocationController" bundle:nil];
            _locationController.delegate = self;
        }
    
        if ([_content.hasLocation boolValue])
        {
            CLLocationDegrees latitude = [_content.latitude doubleValue];
            CLLocationDegrees longitude = [_content.longitude doubleValue];
            
            [_locationController viewLicationCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
        }

        [self presentModalViewController:_locationController animated:YES];
    }
}

#pragma mark - Table Cells

- (UITableViewCell *)cellForImageName
{
    static NSString *cellID = @"NameCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!self.nameField)
    {
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 285, 30)];
        _nameField.delegate = self;
        _nameField.textAlignment = UITextAlignmentLeft;
        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameField.placeholder = @"Name";
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.textColor = [UIColor tableViewCellTextBlueColor];
        [_nameField setReturnKeyType:UIReturnKeyDone];
        [_nameField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    
    _nameField.text = _content.name;
    [cell addSubview:self.nameField];
    
    return cell;
}

- (UITableViewCell *)cellForImageView
{
    static NSString *cellID = @"ImageCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType =  UITableViewCellAccessoryNone;
    }
    
    if ([_content.hasImage boolValue])
    {
        cell.imageView.image = [UIImage imageWithData:_imageData];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        cell.textLabel.text = @"Take a Photo";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    
    return cell;
}

- (UITableViewCell *)cellForImageComment
{
    static NSString *cellID = @"ContentCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)];
        _commentView.backgroundColor = [UIColor tableViewCellBackgroundColor];
        _commentView.delegate = self;
        _commentView.editable = YES;
        _commentView.textColor = [UIColor tableViewCellTextBlueColor];
        [_commentView setReturnKeyType:UIReturnKeyDone];
        [_commentView setFont:[UIFont systemFontOfSize:17.0]];
        _commentView.scrollEnabled = YES;
        
        [cell addSubview:self.commentView];
    }
    
    _commentView.text = self.content.comment;
    
    return cell;
}

- (UITableViewCell *)cellForImageLocation
{
    static NSString *cellID = @"LocationCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 195, 60)];
        _locationLabel.backgroundColor = [UIColor tableViewCellBackgroundColor];
        _locationLabel.textColor = [UIColor tableViewCellTextBlueColor];
        [_commentView setFont:[UIFont systemFontOfSize:17.0]];

        [cell addSubview:self.commentView];
    }
    
    _locationLabel.text = [NSString stringWithFormat:@"Latitude: %.4f\nLongitude: %.4f", [_content.latitude doubleValue], [_content.longitude doubleValue]];
    _locationLabel.numberOfLines = 2;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextField & UITextView Delegate Methods


- (void)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //if the textfield is empty, the white space is not allowed
    if ([textField.text length] == 0)
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _content.name = textField.text;
    [self saveContent];
}

- (BOOL)enableEnterKeyForTextView:(UITextView *)view
{
    if ([view.text hasSuffix:@"."] || [view.text hasSuffix:@"。"]) {
        return YES;
    }
    if ([view.text hasSuffix:@"?"] || [view.text hasSuffix:@"？"]) {
        return YES;
    }
    if ([view.text hasSuffix:@"!"] || [view.text hasSuffix:@"！"]) {
        return YES;
    }
    if ([view.text hasSuffix:@"~"] || [view.text hasSuffix:@"～"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (![self enableEnterKeyForTextView:textView]) {
            [textView resignFirstResponder];
            // Return FALSE so that the final '\n' character doesn't get added
            return NO;
        }
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _content.comment = textView.text;
    [self saveContent];
}

#pragma mark - UIActionSheet Delegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //control image capture
    if (actionSheet == _imageSelectionSheet)
    {
        switch (buttonIndex)
        {
            case 0: {
                [self useCameraRoll];
            } break;
                
            case 1: {
                [self useCamera];
            } break;
                
            default:
                break;
        }
    }
    
    //control cancel action
    if (actionSheet == _cancelActionSheet)
    {
        switch (buttonIndex)
        {
            case 0:{
                [self deleteContent];
                [self dismissModalViewControllerAnimated:YES];
            } break;
                
            default:
                //do nothing
                break;
        }
    }
}

#pragma mark - Delete Content

- (void)deleteContent
{
    [self.managedObjectContext deleteObject:_content];
    [self saveContent];
}

#pragma mark - Image Picker Delegate Methods

- (void)useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        
        newMedia = YES;
    }
}

- (void)useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [self dismissModalViewControllerAnimated:YES];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //JPEG format
        _content.image = UIImageJPEGRepresentation(image, 1.0);
        
        //PNG format
        //_content.image = UIImagePNGRepresentation(image);
        
        _content.hasImage = [NSNumber numberWithBool:YES];
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }

    [self saveContent];
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Image Location Controller Delegate

- (void)imageLocationController:(ImageLocationController *)controller receiveImageLocation:(CLLocationCoordinate2D)coordinate
{
    _content.hasLocation = [NSNumber numberWithBool:YES];
    _content.latitude = [NSNumber numberWithDouble:coordinate.latitude];
    _content.longitude = [NSNumber numberWithDouble:coordinate.longitude];
    
    [self saveContent];
}

- (void)saveContent
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

@end
