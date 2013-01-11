//
//  ImageViewController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-26.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet    UIBarButtonItem *doneButton;
@property (strong, nonatomic)           UIImageView     *imageView;
@property (strong, nonatomic)           NSData          *imageData;

- (IBAction)done;

@end
