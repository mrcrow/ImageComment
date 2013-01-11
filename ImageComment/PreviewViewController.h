//
//  PreviewViewController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 13-1-10.
//  Copyright (c) 2013年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet    UIScrollView    *scrollView;
@property (weak, nonatomic) IBOutlet    UIImageView     *imageView;
@property (strong, nonatomic)           NSData          *imageData;

- (void)presentMode;

@end
