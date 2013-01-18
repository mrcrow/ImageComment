//
//  ImageContent.h
//  ImageComment
//
//  Created by Wu Wenzhi on 13-1-17.
//  Copyright (c) 2013年 Wu Wenzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageContent : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * hasImage;
@property (nonatomic, retain) NSNumber * hasLocation;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * folderPath;

@end
