//
//  FootView.h
//  News
//
//  Created by Martin on 3/12/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FootView;
@protocol FootViewDelegate <NSObject>
@optional
- (void)updateDate:(FootView*)tgfootview;

@end

@interface FootView : UIView
- (instancetype)initWithFrame:(CGRect)frame withButtonFrame:(CGRect)btnFrame;
@property(nonatomic,weak) id<FootViewDelegate> delegate;

@end
