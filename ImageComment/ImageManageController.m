//
//  ImageManageController.m
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import "ImageManageController.h"
#import "ColorExtention.h"
       
#define IMAGE_CELL_HEIGHT   self.view.bounds.size.height / 2.5
#define COMMENT_CELL_HEIGHT 240.0

@interface ImageManageController ()
//@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField   *nameField;
@property (strong, nonatomic) UITextField   *locationField;
@property (strong, nonatomic) UITextView    *commentView;
@property (strong, nonatomic) NSData        *imageData;
@end

@implementation ImageManageController
@synthesize managedObjectContext = _managedObjectContext, locationController = _locationController;
@synthesize nameField = _nameField, locationField = _locationField, commentView = _commentView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)cance
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)done
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setLocationController:nil];
    [self setManagedObjectContext:nil];
    [self setNameField:nil];
    [self setLocationField:nil];
    [self setCommentView:nil];
    //[self setImageView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                       [NSNumber numberWithInt:1],      //Comment
                       [NSNumber numberWithInt:1],      //Location
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
        case 2: return [self cellForImageComment];
        case 3: return [self cellForImageLocation];
        default: return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return IMAGE_CELL_HEIGHT;
    }
    
    if (indexPath.section == 2)
    {
        return COMMENT_CELL_HEIGHT;
    }
    
    return [self.tableView rowHeight];
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
    
    [cell addSubview:self.nameField];
    
    return cell;
}

- (void)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}

- (UITableViewCell *)cellForImageView
{
    static NSString *cellID = @"ImageCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if (_imageData)
    {
        cell.imageView.image = [UIImage imageWithData:_imageData];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"placeHolder"];
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
        
        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 240)];
        _commentView.backgroundColor = [UIColor tableViewCellBackgroundColor];
        _commentView.delegate = self;
        _commentView.editable = YES;
        _commentView.textColor = [UIColor tableViewCellTextBlueColor];
        [_commentView setReturnKeyType:UIReturnKeyDone];
        [_commentView setFont:[UIFont systemFontOfSize:17.0]];
        _commentView.scrollEnabled = YES;
        
        [cell addSubview:self.commentView];
    }
    
    return cell;
}

- (UITableViewCell *)cellForImageLocation
{
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
