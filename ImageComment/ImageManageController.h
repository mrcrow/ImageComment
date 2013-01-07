//
//  ImageManageController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageContent.h"
#import "ImageLocationController.h"
#import "ImageViewController.h"

@interface ImageManageController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, ImageLocationControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext    *managedObjectContext;
@property (strong, nonatomic) ImageLocationController   *locationController;
@property (strong, nonatomic) ImageViewController       *imageController;

@property (strong, nonatomic) ImageContent  *content;

@end
