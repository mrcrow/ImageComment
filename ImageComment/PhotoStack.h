//
//  PhotoStack.h
//  ImageComment
//
//  Created by Wu Wenzhi on 13-1-17.
//  Copyright (c) 2013年 Wu Wenzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOPhotoGlobal.h"

@interface PhotoStack : NSObject <EGOPhotoSource>
{
    NSArray *_photos;
	NSInteger _numberOfPhotos;
}

- (id)initWithPhotos:(NSArray *)photos;

@end
