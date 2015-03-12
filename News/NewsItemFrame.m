//
//  NewsItemFrame.m
//  News
//
//  Created by Martin on 3/13/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//


#import "NewsItemFrame.h"
#import "News.h"
@interface NewsItemFrame()
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, strong) News *news;

@end

@implementation NewsItemFrame

- (instancetype) initFrameWithNews:(News *)news withViewFrame:(CGRect) rect
{
    self = [super init];
    if (self) {
        self.viewFrame = rect;
        self.news = news;
    }
    return self;
}

- (void) setNews:(News *)news
{

    
}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
