//
//  ImageContent.h
//  ImageComment
//
//  Created by Wu Wenzhi on 13-1-7.
//  Copyright (c) 2013年 Wu Wenzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageContent : NSManagedObject

@property (nonatomic, retain) NSString * imageComment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * hasImage;
@property (nonatomic, retain) NSString * imageID;

@end
