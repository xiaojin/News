//
//  ImageCache.h
//  News
//
//  Created by jin on 4/05/2015.
//  Copyright (c) 2015 Martin. All rights reserved.
//
/**
 *  Image cache implementation
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageCache : NSObject{
@private
  NSCache *memCache;
  NSFileManager *fileManager;
  NSString *cacheDir;
  dispatch_queue_t ioQueue;
}

+ (ImageCache *)shareCache;
/**
 *  Memory Cache
 *
 *  @param image image
 *  @param key   key for image
 */
- (void)cacheImageToMemory:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)getImageFromMemoryForKey:(NSString *)key;

/**
 *  File Cache
 *
 *  @param image     image
 *  @param key       key for image
 *  @param imageType image type, jpg,png
 */
- (void)cacheImageToFile:(UIImage *)image forKey:(NSString *)key ofType:(NSString *)imageType;
- (UIImage *)getImageFromFileForKey:(NSString *)key;

@end
