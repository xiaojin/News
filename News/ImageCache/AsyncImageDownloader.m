//
//  AsyncImageDownloader.m
//  News
//
//  Created by jin on 4/05/2015.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import "AsyncImageDownloader.h"

@implementation AsyncImageDownloader

+ (instancetype)shareImageDownloader {
  static AsyncImageDownloader *asynImageDownloader = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    asynImageDownloader = [[self alloc] init];
  });
  return asynImageDownloader;
}

- (void)downloadImageWithURL:(NSURL *)url
                    complete:(ImageDownloadedBlock)completeBlock {
  ImageCache *imageCache = [ImageCache shareCache];
  NSString *imageUrl = [url absoluteString];
  //first try to get the image from memory
  UIImage *image = [imageCache getImageFromMemoryForKey:imageUrl];
  if (image) {
    if (completeBlock) {
      NSLog(@"Image exists in memory");
      completeBlock(image, nil, url);
    }
    return;
  }
  // If not, get the image from file
  image = [imageCache getImageFromFileForKey:imageUrl];
  if (image) {
    if (completeBlock) {
      NSLog(@"image exists in file");
      completeBlock(image,nil,url);
    }
    
    [imageCache cacheImageToMemory:image forKey:imageUrl];
    return;
  }
  
  // Can't find memory in both location, try to download image from
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSError *error;
    NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *image = [UIImage imageWithData:imageData];
      if (image) {
        // push the image into memory
        [imageCache cacheImageToMemory:image forKey:imageUrl];
        NSString *extension = [imageUrl substringFromIndex:imageUrl.length - 3];
        NSString *imageType = @"jpg";
        
        if ([extension isEqualToString:@"jpg"]) {
          imageType = @"jpg";
        } else {
          imageType = @"png";
        }
        // then push  the image into the local file
        [imageCache cacheImageToFile:image forKey:imageUrl ofType:imageType];
      }
      if (completeBlock) {
        completeBlock(image,error,url);
      }
    });
  });
}
@end
