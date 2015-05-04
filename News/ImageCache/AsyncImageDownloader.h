//
//  AsyncImageDownloader.h
//  News
//
//  Created by jin on 4/05/2015.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCache.h"
typedef void(^ImageDownloadedBlock)(UIImage *image, NSError *error, NSURL *imageURL);

@interface AsyncImageDownloader : NSObject
+ (instancetype)shareImageDownloader;

- (void)downloadImageWithURL:(NSURL *)url complete:(ImageDownloadedBlock)completeBlock;
@end
