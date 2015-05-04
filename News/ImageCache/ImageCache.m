//
//  ImageCache.m
//  News
//
//  Created by jin on 4/05/2015.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache

+ (ImageCache *)shareCache {
  static ImageCache *imageCache = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    imageCache = [[self alloc]init];
  });
  return imageCache;
}

-(instancetype)init{
  if (self ==[self init]) {
    ioQueue = dispatch_queue_create("com.martin.xiao", DISPATCH_QUEUE_SERIAL);
    
    memCache = [[NSCache alloc]init];
    memCache.name = @"image_cache";
    fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    cacheDir = [paths objectAtIndex:0];
  }
  return self;
}

- (void)cacheImageToMemory:(UIImage *)image forKey:(NSString *)key {
  if (image) {
    [memCache setObject:image forKey:key];
  }
}

- (UIImage *)getImageFromMemoryForKey:(NSString *)key {
  return [memCache objectForKey:key];
}

- (void)cacheImageToFile:(UIImage *)image
                  forKey:(NSString *)key
                  ofType:(NSString *)imageType {
  
  if (!image || !key || !imageType) {
    return;
  }
  
  dispatch_async(ioQueue, ^{
    NSRange range = [key rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *filename = [key substringFromIndex:range.location+1];
    NSString *filepath = [cacheDir stringByAppendingPathComponent:filename];
    NSData *imageData = nil;
    
    if ([imageType isEqualToString:@"jpg"]) {
      imageData = UIImageJPEGRepresentation(image, 1.0);
    } else {
      imageData = UIImagePNGRepresentation(image);
    }
    
    if (imageData) {
      [imageData writeToFile:filepath atomically:YES];
    }
  });
}

- (UIImage *)getImageFromFileForKey:(NSString *)key {
  if (!key) {
    return nil;
  }
  
  NSRange range = [key rangeOfString:@"/" options:NSBackwardsSearch];
  NSString *filename = [key substringFromIndex:range.location+1];
  NSString *filepath = [cacheDir stringByAppendingPathComponent:filename];
  
  if ([fileManager fileExistsAtPath:filepath]) {
    UIImage *image = [UIImage imageWithContentsOfFile:filepath];
    return image;
  }
  return nil;
}
@end
