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

- (News*)getNews{
    return _news;
}

- (void) setNews:(News *)news
{
    if (_news!=news) {
        [_news release];
        _news = [news retain];
        CGFloat padding = 10;
        CGFloat paddingTop = 5;
        CGSize frameSize = self.viewFrame.size;
        //    _iconFrame = CGRectMake(padding, padding, iconW, iconH);
        
        CGSize titleSize = [self initSizeWithText:self.news.title withSize:CGSizeMake((frameSize.width - 2*padding), MAXFLOAT) withFont:NewsTitleFont];
        CGFloat nameW = titleSize.width;
        CGFloat nameH = titleSize.height;
        CGFloat pointX = padding;
        CGFloat pointY = paddingTop;
        
        _titleFrame = CGRectMake(pointX, pointY, nameW, nameH);
        
        CGSize textSize = [self initSizeWithText:self.news.desc withSize:CGSizeMake((frameSize.width - 3*padding-PicWith), MAXFLOAT) withFont:NewsTextFont];
        CGFloat textW = textSize.width;
        CGFloat textH = textSize.height;
        CGFloat textPointX = padding;
        CGFloat textPointY = CGRectGetMaxY(_titleFrame)+ paddingTop;
        _textFrame = CGRectMake(textPointX, textPointY, textW, textH);
        
        
        CGFloat picPointX = frameSize.width-padding-PicWith;
        CGFloat picPointY = CGRectGetMaxY(_titleFrame);
        _pictureFrame = CGRectMake(picPointX, picPointY, PicWith, PicHeight);
        if (CGRectGetMaxY(_textFrame) > CGRectGetMaxY(_pictureFrame)) {
            _cellHeight = CGRectGetMaxY(_textFrame) +20;
        } else {
            _cellHeight = CGRectGetMaxY(_pictureFrame) +20;
        }

    }

    
}

- (CGSize) initSizeWithText:(NSString *) text withSize:(CGSize) Size withFont:(UIFont*)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)dealloc
{
    [_news release];
    _news = nil;
    [super dealloc];
}

@end
