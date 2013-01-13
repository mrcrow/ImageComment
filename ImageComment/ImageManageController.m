//
//  ImageManageController.m
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import "ImageManageController.h"
#import "EGOPhotoGlobal.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"
       
#define BIG_CELL_HEIGHT 200.0
#define SMALL_CELL_HEIGHT 58.0

@interface ImageManageController ()
@property (strong, nonatomic)   UITextField             *nameField;
@property (strong, nonatomic)   UITextView              *commentView;

@property                       BOOL                    newMedia;

@property (strong, nonatomic)   UIActionSheet           *imageSelectionSheet;
@property (strong, nonatomic)   UIActionSheet           *cancelActionSheet;

//@property (strong, nonatomic)   UIImageView             *imageView;
//@property (strong, nonatomic)   UIImagePickerController *picker;
@end

@implementation ImageManageController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize nameField = _nameField, commentView = _commentView;
@synthesize content = _content;
@synthesize newMedia, previewMode;
@synthesize delegate;
@synthesize imageSelectionSheet = _imageSelectionSheet, cancelActionSheet = _cancelActionSheet;
//@synthesize picker;
//@synthesize imageView = _imageView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Image", @"Image object");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self initialzeViewButtons];
    
    if (!previewMode)
    {
        _content.date = [NSDate date];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setManagedObjectContext:nil];
    [self setNameField:nil];
    [self setCommentView:nil];
    //[self setImageView:nil];
    [self setImageSelectionSheet:nil];
    [self setCancelActionSheet:nil];
    [self setDelegate:nil];
    [self setContent:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [delegate imageManagerController:self didFinishEditContent:YES];
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
        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showImageSelectionSheet)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:doneButton, cameraButton, nil];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

- (void)cancel
{
    if (!self.cancelActionSheet)
    {
        _cancelActionSheet = [[UIActionSheet alloc] initWithTitle:@"Record will not be saved" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    }
    [_cancelActionSheet showInView:self.view];
}

- (void)done
{
    if ([_nameField.text length] != 0 && [_content.hasImage boolValue] && [_content.hasLocation boolValue])
    {
        [self dismissModalViewControllerAnimated:YES];
        [self saveContent];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The image attributes are not completed" message:@"Please check the name, photo and location information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.navigationItem setHidesBackButton:editing animated:YES];
    [self.commentView setEditable:editing];
    [self.nameField setEnabled:editing];
    
    if (!editing)
    {
        [self saveContent];
        [self allResignFirstResponse];
    }
}

- (void)allResignFirstResponse
{
    if (_commentView.isFirstResponder)
    {
        [_commentView resignFirstResponder];
    }
    
    if (_nameField.isFirstResponder)
    {
        [_nameField resignFirstResponder];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self allResignFirstResponse];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: {
          return nil;
        } break;
            
        case 1: {
            return NSLocalizedString(@"Photo", @"Photo");
        } break;
            
        case 2: {
            return NSLocalizedString(@"Location", @"Location");
        } break;
            
        default:
            return NSLocalizedString(@"Comments", @"Comments");
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        return NSLocalizedString(@"Typing symbols like '.', '!' or '?' can start a new paragraph.", @"Comment Tip");
        ;
    }
    
    return nil;
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
    if (indexPath.section == 3) //Comment
    {
        return BIG_CELL_HEIGHT;
    }
    
    return [self.tableView rowHeight];
}

#pragma mark - UITableView Selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //select image cell
    if (indexPath.section == 1)
    {
        if (previewMode)
        {
            [self pushImagePreviewView];
        }
        else
        {
            if ([_content.hasImage boolValue])
            {
                [self pushImagePreviewView];
            }
            else
            {
                [self showImageSelectionSheet];
            }
        }
    }

    
    //select location cell
    if (indexPath.section == 2)
    {
        [self pushLocationViewAllowEditing:previewMode];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showImageSelectionSheet
{
    if (!self.imageSelectionSheet)
    {
        _imageSelectionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", @"Use camera"), NSLocalizedString(@"Camera Roll", @"Select from camera roll"), nil];
    }
    
    [_imageSelectionSheet showInView:self.view];
}

- (void)pushImagePreviewView
{    
    MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:nil name:_content.comment image:[UIImage imageWithData:_content.image]];
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    [self.navigationController pushViewController:photoController animated:YES];
}

- (void)pushLocationViewAllowEditing:(BOOL)allow
{
    //push location view
    ImageLocationController *locationController = [[ImageLocationController alloc] initWithNibName:@"ImageLocationController" bundle:nil];
    locationController.content = self.content;
    locationController.delegate = self;
    locationController.previewMode = allow;
    locationController.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController pushViewController:locationController animated:YES];
}

#pragma mark - Table Cells

- (UITableViewCell *)cellForImageName
{
    static NSString *cellID = @"NameCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!self.nameField)
    {
        self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 8, 285, 30)];
        _nameField.delegate = self;
        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameField.placeholder = @"Name";
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.textColor = [UIColor tableViewCellTextBlueColor];
        [_nameField setReturnKeyType:UIReturnKeyDone];
        [_nameField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
        self.nameField.enabled = !previewMode;
    }
    
    if ([_content.name length] != 0)
    {
        _nameField.textAlignment = UITextAlignmentCenter;
    }
    else
    {
        _nameField.textAlignment = UITextAlignmentLeft;
    }
    _nameField.text = _content.name;
    [cell addSubview:self.nameField];
    
    return cell;
}

#define IMAGE_HEIGHT            160.0

#define PHOTO_WIDTH_PORTRAIT    320.0
#define PHOTO_HEIGHT_PORTRAIT   460.0
#define PHOTO_WIDTH_LANDSCAPE   PHOTO_HEIGHT_PORTRAIT
#define PHOTO_HEIGHT_LANDSCAPE  PHOTO_WIDTH_PORTRAIT

- (UITableViewCell *)cellForImageView
{
    static NSString *cellID = @"ImageCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text = NSLocalizedString(@"Image", @"Image");
    cell.detailTextLabel.textColor = [UIColor tableViewCellTextBlueColor];
    
    if ([_content.hasImage boolValue])
    {
        cell.detailTextLabel.text = NSLocalizedString(@"Preview Image", @"Preview image data");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.detailTextLabel.text = NSLocalizedString(@"No Image", @"Content has no image");
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    /*
    if (!self.imageView)
    {
        double width = PHOTO_WIDTH_LANDSCAPE * IMAGE_HEIGHT / PHOTO_HEIGHT_LANDSCAPE;
        double x = (PHOTO_WIDTH_PORTRAIT - width) / 2;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 20, width, IMAGE_HEIGHT)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell addSubview:_imageView];
    }
    
    if ([_content.hasImage boolValue])
    {
        UIImage *image = [UIImage imageWithData:_content.image];
        
        double width = 0.0;
        if (image.size.height > image.size.width)
        {
            width = IMAGE_HEIGHT * PHOTO_WIDTH_PORTRAIT / PHOTO_HEIGHT_PORTRAIT;
        }
        else
        {
            width = PHOTO_WIDTH_LANDSCAPE * IMAGE_HEIGHT / PHOTO_HEIGHT_LANDSCAPE;
        }
        
        CGSize newSize = CGSizeMake(width, IMAGE_HEIGHT);
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize);
        // Tell the old image to draw in this new context, with the desired
        // new size
        [image drawInRect:CGRectMake(0 , 0, newSize.width, newSize.height)];
        // Get the new image from the context
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // End the context
        UIGraphicsEndImageContext();
        
        [_imageView setImage:newImage];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        _imageView.image = [UIImage imageNamed:@"placeholder"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    */
}

- (UITableViewCell *)cellForImageComment
{
    static NSString *cellID = @"ContentCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(12, 5, 295, 190)];
        _commentView.backgroundColor = [UIColor tableViewCellBackgroundColor];
        _commentView.delegate = self;
        _commentView.textColor = [UIColor tableViewCellTextBlueColor];
        [_commentView setReturnKeyType:UIReturnKeyDone];
        [_commentView setFont:[UIFont systemFontOfSize:17.0]];
        _commentView.scrollEnabled = YES;
        
        if (previewMode)
        {
            self.commentView.editable = self.tableView.isEditing;
        }
        else
        {
            self.commentView.editable = YES;
        }
        
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:17]];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = @"Coordinate";
    
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    
    if ([_content.hasLocation boolValue])
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"φ:%.3f, λ:%.3f", [_content.latitude doubleValue], [_content.longitude doubleValue]];
    }
    else
    {
        cell.detailTextLabel.text = @"Unknown";
    }

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
    
    if ([textField.text length] != 0)
    {
        textField.textAlignment = UITextAlignmentCenter;
    }
    else
    {
        textField.textAlignment = UITextAlignmentLeft;
    }
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
                [self useCamera];
            } break;
                
            case 1: {
                [self usePhotoAlbum];
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
}

#pragma mark - Image Picker Delegate Methods

- (void)useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerView.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        pickerView.allowsEditing = YES;
        pickerView.showsCameraControls = YES;
        
        [self presentModalViewController:pickerView animated:YES];
        
        newMedia = YES;
    }
}

- (void)usePhotoAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
        pickerView.delegate = self;
        pickerView.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerView.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        pickerView.allowsEditing = NO;
        [self presentModalViewController:pickerView animated:YES];
        newMedia = NO;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    picker.delegate = nil;
    
    [picker dismissModalViewControllerAnimated:YES];
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    
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
        
        [self.tableView reloadData];
        //[NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
    }
}

/*
- (void)useImage:(UIImage *)image {
    
    double width = 0.0;
    if (image.size.height > image.size.width)
    {
        width = IMAGE_HEIGHT * PHOTO_WIDTH_PORTRAIT / PHOTO_HEIGHT_PORTRAIT;
    }
    else
    {
        width = PHOTO_WIDTH_LANDSCAPE * IMAGE_HEIGHT / PHOTO_HEIGHT_LANDSCAPE;
    }
    
    CGSize newSize = CGSizeMake(width, IMAGE_HEIGHT);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0 , 0, newSize.width, newSize.height)];
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    if (!self.imageView)
    {
        //double width = PHOTO_WIDTH_LANDSCAPE * IMAGE_HEIGHT / PHOTO_HEIGHT_LANDSCAPE;
        //double x = (PHOTO_WIDTH_PORTRAIT - 310) / 2;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 320, IMAGE_HEIGHT)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.cornerRadius = 10.0;
        _imageView.clipsToBounds = YES;
    }
    
    [_imageView setImage:newImage];
    
    [self.tableView reloadData];
}*/

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

- (void)imageLocationController:(ImageLocationController *)controller didFinishLocating:(BOOL)success
{
    if (success)
    {
        [self.tableView reloadData];
    }
}

#pragma mark - Content save

- (void)saveContent
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error = nil;
    if (![context save:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
