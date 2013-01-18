//
//  Photo.m
//  ImageComment
//
//  Created by Wu Wenzhi on 13-1-15.
//  Copyright (c) 2013年 Wu Wenzhi. All rights reserved.
//

#import "Photo.h"
#import <CoreLocation/CoreLocation.h>

@implementation Photo
@synthesize URL = _URL, caption = _caption, image = _image ,failed = _failed, size = _size;

- (id)initWithImageURL:(NSURL *)URL name:(NSString *)name image:(UIImage *)image
{
	if (self = [super init])
    {
		_URL = [URL retain];
		_caption = [name retain];
		_image = [image retain];
	}
	return self;
}

- (id)initWithLocalPhotoPath:(NSString *)path name:(NSString *)name
{
    return [self initWithImageURL:nil name:name image:[UIImage imageWithContentsOfFile:path]];
}

- (id)initWithLocalPhotoPath:(NSString *)path
{
    return [self initWithImageURL:nil name:nil image:[UIImage imageWithContentsOfFile:path]];
}

- (id)initWithImageURL:(NSURL *)URL name:(NSString *)name
{
    return [self initWithImageURL:URL name:name image:nil];
}

- (id)initWithImageURL:(NSURL *)URL
{
    return [self initWithImageURL:URL name:nil image:nil];
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImageURL:nil name:nil image:image];
}

- (void)dealloc
{	
	[_URL release], _URL = nil;
	[_image release], _image = nil;
	[_caption release], _caption = nil;
	
	[super dealloc];
}

@end