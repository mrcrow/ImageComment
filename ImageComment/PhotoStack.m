//
//  PhotoStack.m
//  ImageComment
//
//  Created by Wu Wenzhi on 13-1-17.
//  Copyright (c) 2013年 Wu Wenzhi. All rights reserved.
//

#import "PhotoStack.h"

@implementation PhotoStack
@synthesize photos = _photos, numberOfPhotos = _numberOfPhotos;

- (id)initWithPhotos:(NSArray *)photos
{
	if (self = [super init])
    {
		_photos = [photos retain];
		_numberOfPhotos = [_photos count];
	}
	return self;
}

- (id <EGOPhoto>)photoAtIndex:(NSInteger)index
{	
	return [_photos objectAtIndex:index];
}

- (void)dealloc
{	
	[_photos release], _photos = nil;
	[super dealloc];
}

@end
