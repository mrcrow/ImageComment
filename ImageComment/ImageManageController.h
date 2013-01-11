//
//  ImageManageController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageContent.h"
#import "ColorExtention.h"
#import "ImageLocationController.h"
#import "ImageViewController.h"
#import "PreviewViewController.h"

@protocol ImageManagerControllerDelegate;

@interface ImageManageController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageLocationControllerDelegate>

@property (strong, nonatomic)   NSManagedObjectContext          *managedObjectContext;
@property (strong, nonatomic)   ImageContent                    *content;
@property                       BOOL                            previewMode;

@property (weak, nonatomic) id <ImageManagerControllerDelegate> delegate;

- (void)initialzeViewButtons;

@end

@protocol ImageManagerControllerDelegate 

- (void)imageManagerController:(ImageManageController *)controller didFinishEditContent:(BOOL)success;

@end