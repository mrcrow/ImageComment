//
//  ImageViewController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-20.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageContent.h"

@interface ImageViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)manageImageContentView:(ImageContent *)contnet;

@end
