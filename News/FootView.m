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
@property (strong, nonatomic)  UIActivityIndicatorView *activityTG;
@property (strong, nonatomic)  UILabel *lblTGLoading;
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
+ (instancetype) footerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadButton" owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame withButtonFrame:(CGRect)btnFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnTG = [[UIButton alloc]initWithFrame:btnFrame];
        [self.btnTG setTitle:@"Add More" forState:UIControlStateNormal];
        [self.btnTG setBackgroundColor:[UIColor orangeColor]];
        [self.btnTG addTarget:self action:@selector(loadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnTG];
        self.tgControlView = [[UIView alloc]initWithFrame:btnFrame];
        [self insertSubview:self.tgControlView belowSubview:self.btnTG];
     
        CGFloat lblWidth = btnFrame.size.width;
        CGFloat lblHeigth = btnFrame.size.height;
        CGFloat lblPointX = (frame.size.width -lblWidth/2)/2;
        CGFloat lblPointY = (frame.size.height -lblHeigth)/2;
        self.lblTGLoading = [[UILabel alloc]initWithFrame:CGRectMake(lblPointX, lblPointY, lblWidth, lblHeigth)];
        [self.lblTGLoading setTextAlignment:NSTextAlignmentCenter];
        [self.lblTGLoading setText:@"Loading....."];
        [self.lblTGLoading setFont:[UIFont systemFontOfSize:13.0f]];
        [self.tgControlView addSubview:self.lblTGLoading];
        
        self.activityTG = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityTG setFrame:CGRectMake((lblPointX-20.0f), ((frame.size.height-CGRectGetHeight(self.activityTG.frame))/2), CGRectGetWidth(self.activityTG.frame), CGRectGetHeight(self.activityTG.frame))];
        [self.tgControlView addSubview:self.activityTG];
        
    }
    return self;
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

@end
