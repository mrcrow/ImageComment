//
//  LocationViewController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-21.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PopoverView.h"

//@protocol ImageLocationControllerDelegate;

@protocol ImageLocationControllerDelegate;

@interface ImageLocationController : UIViewController <PopoverViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet    MKMapView                   *mapView;
@property (strong, nonatomic)           UIImageView                 *centerTarget;
@property (strong, nonatomic)           ImageContent                *content;
@property (strong, nonatomic)           NSManagedObjectContext      *managedObjectContext;
@property                               BOOL                        previewMode;

@property (weak, nonatomic) id <ImageLocationControllerDelegate>    delegate;

@end

@protocol ImageLocationControllerDelegate

- (void)imageLocationController:(ImageLocationController *)controller didFinishLocating:(BOOL)success;

@end