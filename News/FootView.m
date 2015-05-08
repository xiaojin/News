//
//  FootView.m
//  News
//
//  Created by Martin on 3/12/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import "FootView.h"
@interface FootView ()
@property (strong, nonatomic)  UIButton *btnTG;
@property (strong, nonatomic)  UIView *tgControlView;
- (IBAction)loadBtnClick:(id)sender;

@end

@implementation FootView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
 
 
}
*/

- (instancetype)initWithFrame:(CGRect)frame withButtonFrame:(CGRect)btnFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *tgbtn= [[UIButton alloc]initWithFrame:btnFrame];
        [tgbtn setTitle:@"Add More" forState:UIControlStateNormal];
        [tgbtn setBackgroundColor:[UIColor orangeColor]];
        [tgbtn addTarget:self action:@selector(loadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tgbtn];
        self.btnTG = tgbtn;
        [tgbtn release];
        UIView *tgControlView = [[UIView alloc]initWithFrame:btnFrame];
     
        CGFloat lblWidth = btnFrame.size.width;
        CGFloat lblHeigth = btnFrame.size.height;
        CGFloat lblPointX = (frame.size.width -lblWidth)/2;
        CGFloat lblPointY = (frame.size.height -lblHeigth)/2;
        UILabel *lblTGLoading = [[UILabel alloc]initWithFrame:CGRectMake(lblPointX, lblPointY, lblWidth, lblHeigth)];
        [lblTGLoading setTextAlignment:NSTextAlignmentCenter];
        [lblTGLoading setText:@"Loading....."];
        [lblTGLoading setFont:[UIFont systemFontOfSize:13.0f]];
        [tgControlView addSubview:lblTGLoading];
        
        UIActivityIndicatorView *activityTG = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityTG startAnimating];
        
        CGFloat actWidth = CGRectGetWidth(activityTG.frame);
        CGFloat actHeigth = CGRectGetHeight(activityTG.frame);
        CGFloat actPointX = 20.0f;
        CGFloat actPointY = (frame.size.height -actHeigth)/2;
        
        activityTG.frame = CGRectMake(actPointX, actPointY, actWidth, actHeigth);
        [tgControlView addSubview:activityTG];
        [activityTG release];
        [lblTGLoading release];
        [self insertSubview:tgControlView belowSubview:self.btnTG];
        self.tgControlView = tgControlView;
        [tgControlView release];
        [self startAnimation];
    }
    return self;
}

- (void)startAnimation
{
    self.btnTG.hidden = YES;
    self.tgControlView.hidden= NO;
}
- (void)stopAnimation
{
    self.btnTG.hidden = NO;
    self.tgControlView.hidden= NO;
}

- (IBAction)loadBtnClick:(id)sender {
    self.btnTG.hidden = YES;
    self.tgControlView.hidden= NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(updateDate:)]) {
            [_delegate updateDate:self];
        }
        self.btnTG.hidden = NO;
        self.tgControlView.hidden = YES;
    });
    
}

- (void)dealloc
{
    [_btnTG release];
    _btnTG = nil;
    [_tgControlView release];
    _tgControlView = nil;
    [super dealloc];
}

@end
