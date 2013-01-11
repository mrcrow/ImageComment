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
@synthesize imageData = _imageData, imageView = _imageView;

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
    [self setupScrollview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageData:nil];
    [self setDoneButton:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

#pragma mark - ScrollView and ImageView

#define SCROLL_HEIGHT           416.0
#define NAVBAR_HEIGHT           44.0
#define PHOTO_WIDTH_PORTRAIT    320.0
#define PHOTO_HEIGHT_PORTRAIT   460.0

- (void)setupScrollview
{
    UIImage *image = [UIImage imageWithData:_imageData];
    
    if (image.size.height > image.size.width)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 460.0)];
        _imageView.image = [UIImage imageWithData:_imageData];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, 320.0, SCROLL_HEIGHT)];
        [scrollView addSubview:_imageView];
        
        scrollView.bounces = NO;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 3.0;
        scrollView.delegate = self;
        
        [self.view addSubview:scrollView];
    }
    else
    {
        double height = PHOTO_WIDTH_PORTRAIT * PHOTO_WIDTH_PORTRAIT / PHOTO_HEIGHT_PORTRAIT;
        double y = (SCROLL_HEIGHT - height) / 2;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 320.0, height)];
        _imageView.image = [UIImage imageWithData:_imageData];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, 320.0, SCROLL_HEIGHT)];
        [scrollView addSubview:_imageView];
        
        scrollView.bounces = NO;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 4.0;
        scrollView.delegate = self;
        
        [self.view addSubview:scrollView];
    }
}

#pragma mark - Button functions

- (IBAction)done
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Enable Zoom in and out

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end
