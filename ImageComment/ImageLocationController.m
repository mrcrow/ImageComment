//
//  LocationViewController.m
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-21.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import "ImageLocationController.h"

@interface ImageLocationController ()
@property NSMutableArray *location;
@end

@implementation ImageLocationController
@synthesize location = _location, centerTarget;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Location";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupController];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setLocation:nil];
    [self setDelegate:nil];
    [self setCenterTarget:nil];
    [super viewDidUnload];
}

#pragma mark - Buttons Methods

#define MapTypeArray [NSArray arrayWithObjects:@"Standard Map", @"Satellite Map", @"Hybrid Map", nil]

- (void)setupController
{
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    UIBarButtonItem *locateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPinToMap)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl target:self action:@selector(showMapTypePop)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishLocating)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    self.toolbarItems = [NSArray arrayWithObjects:trackingButton, space, locateButton, space, typeButton, nil];
    
    _location = [NSMutableArray array];
    
    centerTarget = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"target"]];
    centerTarget.contentMode = UIViewContentModeScaleAspectFit;
    centerTarget.center = self.mapView.center;
}

- (void)addPinToMap
{
    
}

- (void)finishLocating
{
    
}

- (void)showMapTypePop
{
   [PopoverView showPopoverAtPoint:CGPointMake(330.0, 370.0) inView:self.mapView withTitle:@"MapType" withStringArray:MapTypeArray delegate:self];
}

#pragma mark - Popover View Delegate Method

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    //Figure out which string was selected, store in "string"
    NSString *string = [MapTypeArray objectAtIndex:index];
    
    //Show a success image, with the string from the array
    [popoverView showImage:[UIImage imageNamed:@"success"] withMessage:string];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.mapView cache:YES];
    [UIView commitAnimations];
    
    switch (index) {
        case 0: {
            self.mapView.mapType = MKMapTypeStandard;
        } break;
            
        case 1: {
            self.mapView.mapType = MKMapTypeSatellite;
        } break;
            
        default: {
            self.mapView.mapType = MKMapTypeHybrid;
        } break;
    }
    
    //Dismiss the PopoverView after 0.5 seconds
    [popoverView performSelector:@selector(dismiss) withObject:nil afterDelay:0.5f];
}

@end
