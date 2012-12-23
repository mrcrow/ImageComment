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

@interface LocationViewController : UIViewController <PopoverViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
