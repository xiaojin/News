//
//  UIImageView+AsyncDownload.m
//  News
//
//  Created by jin on 4/05/2015.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import "UIImageView+AsyncDownload.h"

@implementation UIImageView (AsyncDownload)
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
  self.tag = [url absoluteString];
  self.image = placeholder;
  
  if (url) {
    // 
    AsyncImageDownloader *imageLoader = [AsyncImageDownloader shareImageDownloader];
    [imageLoader downloadImageWithURL:url complete:^(UIImage *image, NSError *error, NSURL *imageURL) {
      if (image && [self.tag isEqualToString:[imageURL absoluteString]]) {
        self.image = image;
      } else {
        NSLog(@"error when download:%@", error);
      }
    }];
  }
  
}
@end
