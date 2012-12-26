//
//  ImageViewController.h
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-26.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) NSData *imageData;

- (IBAction)done;

@end
