//
//  NewsItemFrame.h
//  News
//
//  Created by Martin on 3/13/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#define NewsTitleFont [UIFont systemFontOfSize:15.0f]
#define NewsTextFont [UIFont systemFontOfSize:10.0f]
#define PicWith 100
#define PicHeight 80
#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsItemFrame : NSObject
@property (nonatomic, assign, readonly) CGRect titleFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGRect pictureFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
- (instancetype) initFrameWithNews:(News *)news withViewFrame:(CGRect) rect;
- (News*)getNews;
@end
