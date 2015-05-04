//
//  UIImageView+AsyncDownload.h
//  News
//
//  Created by jin on 4/05/2015.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageDownloader.h"
@interface UIImageView (AsyncDownload)
/**
 *  define a tag to avoid the tableview cell load the other image
 */
@property(nonatomic, strong)NSString *tag;

- (void)setImageWithURL: (NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
