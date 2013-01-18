//
//  Photo.h
//  ImageComment
//
//  Created by Wu Wenzhi on 13-1-15.
//  Copyright (c) 2013年 Wu Wenzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EGOPhotoGlobal.h"

@interface Photo : NSObject <EGOPhoto>
{
    NSURL *_URL;
	NSString *_caption;
	CGSize _size;
	UIImage *_image;
	
	BOOL _failed;
}

- (id)initWithLocalPhotoPath:(NSString *)path name:(NSString *)name;
- (id)initWithLocalPhotoPath:(NSString *)path;

- (id)initWithImageURL:(NSURL *)URL name:(NSString *)name;
- (id)initWithImageURL:(NSURL *)URL;

- (id)initWithImage:(UIImage *)image;

@end
