//
//  NewsItemCell.h
//  News
//
//  Created by Martin on 3/12/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItemFrame.h"
@interface NewsItemCell : UITableViewCell
@property (nonatomic, strong) NewsItemFrame *status;
+ (instancetype) NewsWithCell:(UITableView *)tableview;
@end
