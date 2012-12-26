//
//  ImageViewController.m
//  ImageComment
//
//  Created by Wu Wenzhi on 12-12-26.
//  Copyright (c) 2012年 Wu Wenzhi. All rights reserved.
//

#import "ImageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageViewController ()

@end

@implementation ImageViewController
@synthesize doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[doneButton layer] setCornerRadius:10.0f];
    [[doneButton layer] setMasksToBounds:YES];
    [[doneButton layer] setBorderWidth:0.2f];
    
    /* set "green border" on the layer passing it a CGColorRef. */
    [[doneButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    /* set the background color */
    // Core Animation way
    //[[button1 layer] setBackgroundColor:[[UIColor redColor] CGColor]];
    
    // UIView way
    [doneButton setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view from its nib.
    
    doneButton.tintColor = [UIColor blackColor];
    doneButton.titleLabel.text = @"Done";
}

- (IBAction)done
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDoneButton:nil];
    [super viewDidUnload];
}
@end
