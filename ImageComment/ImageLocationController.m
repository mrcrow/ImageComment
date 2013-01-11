//
//  LocationViewController.m
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-21.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import "ImageLocationController.h"

@interface ImageLocationController ()
@property (strong, nonatomic) NSMutableArray *userAnnotation;
@end

@implementation ImageLocationController
@synthesize userAnnotation = _userAnnotation;
@synthesize delegate;
@synthesize centerTarget;
@synthesize content, previewMode, managedObjectContext = __managedObjectContext;

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
    [self setupView];
    [self setupTargetAndAnnotationContainer];
    [self loadLocation];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!previewMode)
    {
        [self.navigationController setToolbarHidden:YES animated:YES];
        self.navigationController.toolbar.barStyle = UIBarStyleDefault;
        [delegate imageLocationController:self didFinishLocating:YES];
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setCenterTarget:nil];
    [self setUserAnnotation:nil];
    [self setContent:nil];
    [self setManagedObjectContext:nil];
    [super viewDidUnload];
}

#pragma mark - View Location Coordinate

- (void)loadLocation
{
    if ([content.hasLocation boolValue])
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([content.latitude doubleValue], [content.longitude doubleValue]);
        
        MKCoordinateRegion area = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200);
        [_mapView setRegion:area animated:YES];
        
        [self clearAnnotationContainer];
        
        MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        annot.title = @"Location";
        annot.coordinate = coordinate;
        annot.subtitle = [NSString stringWithFormat:@"φ:%f, λ:%f", annot.coordinate.latitude, annot.coordinate.longitude];
        
        [self.mapView addAnnotation:annot];
        [_userAnnotation addObject:annot];
    }
}

#pragma mark - Buttons Methods

#define MapTypeArray [NSArray arrayWithObjects:@"Standard", @"Satellite", @"Hybrid", nil]

- (void)setupView
{
    MKUserTrackingBarButtonItem *trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    UIBarButtonItem *locateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPinToMap)];
    //locateButton.style = UIBarButtonItemStyleBordered;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonSystemItemDone target:self action:@selector(showMapTypePop)];

    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:trackingButton, typeButton, nil] animated:YES];
    
    if (!previewMode)
    {
        [self setToolbarItems:[NSArray arrayWithObjects:space, locateButton, space, nil]];
        [self.navigationController setToolbarHidden:NO animated:YES];
        self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    }
}

- (void)addPinToMap
{
    [self clearAnnotationContainer];
    
    CLLocationCoordinate2D coord = [self.mapView centerCoordinate];
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.title = @"Image Location";
    annot.coordinate = coord;
    annot.subtitle = [NSString stringWithFormat:@"φ:%.4f, λ:%.4f", annot.coordinate.latitude, annot.coordinate.longitude];
    
    content.hasLocation = [NSNumber numberWithBool:YES];
    content.latitude = [NSNumber numberWithDouble:coord.latitude];
    content.longitude = [NSNumber numberWithDouble:coord.longitude];
    
    [self.mapView addAnnotation:annot];
    [_userAnnotation addObject:annot];    
}

- (void)clearAnnotationContainer
{
    if ([_userAnnotation count] != 0)
    {
        [self.mapView removeAnnotations:_userAnnotation];
        [_userAnnotation removeAllObjects];
    }
    else
    {
        _userAnnotation = [NSMutableArray array];
    }
}

- (void)showMapTypePop
{
    //UIBarstyle Default -> height = 0.0;
    //UIBarstyle Default -> height = 44.0;
   [PopoverView showPopoverAtPoint:CGPointMake(255.0, 44.0) inView:self.mapView withTitle:@"Map Type" withStringArray:MapTypeArray delegate:self];
}

#pragma mark - MKMapView Delegate Method

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *locationAnnotationIdentifier = @"LocationPinAnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:locationAnnotationIdentifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:locationAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

#pragma mark - Center Target

- (void)setupTargetAndAnnotationContainer
{
    if (!previewMode)
    {
        centerTarget = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"target"]];
        centerTarget.contentMode = UIViewContentModeScaleAspectFit;
        centerTarget.center = self.mapView.center;
        
        //CGFloat x = CGRectGetMidX([[UIScreen mainScreen] applicationFrame]);
        //CGFloat y = CGRectGetMidY([[UIScreen mainScreen] applicationFrame]);
        //centerTarget.center = CGPointMake(x, y);
        
        [self.view addSubview:centerTarget];
        
        self.userAnnotation = [NSMutableArray array];
    }
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
