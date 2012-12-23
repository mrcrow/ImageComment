//
//  ImageManageController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageContent.h"
#import "LocationViewController.h"

@interface ImageManageController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) LocationViewController *locationController;

@end
