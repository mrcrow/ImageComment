//
//  ImageManageController.m
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import "ImageManageController.h"
#import "ColorExtention.h"

@interface ImageManageController ()
@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *locationField;
@property (strong, nonatomic) UITextView *commentView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSData *imageData;
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
    [self setImageView:nil];
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

#pragma mark - Table Cells

- (UITableViewCell *)cellForImageName
{
    static NSString *cellID = @"NameCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

- (UITableViewCell *)cellForImageView
{
    if (!self.imageView)
    {
        CGFloat cellWidth = self.view.bounds.size.width - 20;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 431.25)];
        
    }
}

- (UITableViewCell *)cellForImageComment
{
    return nil;
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
