//
//  NewsItemCell.m
//  News
//
//  Created by Martin on 3/12/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import "NewsItemCell.h"
#import "News.h"
@interface NewsItemCell()
@property(nonatomic, weak)IBOutlet UILabel *lblTitle;
@property(nonatomic, weak)IBOutlet UILabel *lblText;
@property(nonatomic, weak)IBOutlet UIImageView *imagePic;
@end

@implementation NewsItemCell

+ (instancetype) NewsWithCell:(UITableView *)tableview;
{
    static NSString *identity =@"news";
    NewsItemCell * cell = [tableview dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[NewsItemCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *lblTitle = [[UILabel alloc]init];
        [lblTitle setFont:NewsTitleFont];
        [lblTitle setTextColor:[UIColor colorWithRed:36.0f/255.0f green:51.0f/255.0f blue:108.0f/255.0f alpha:1.0f]];
        [lblTitle setNumberOfLines:0];
        [self addSubview:lblTitle];
        self.lblTitle = lblTitle;
        
        UILabel *lblText = [[UILabel alloc]init];
        [lblText setFont:NewsTextFont];
        [lblText setNumberOfLines:0];
        [self addSubview:lblText];
        
        self.lblText = lblText;
        
        UIImageView *imagePic = [[UIImageView alloc] init];
        [self addSubview:imagePic];
        self.imagePic = imagePic;
        
    }
    return  self;
}

- (void)setStatus:(NewsItemFrame *)status
{
    _status = status;
    [self updateFrame];
    [self updateData];
}

- (void)updateFrame
{
    self.imagePic.frame = self.status.pictureFrame;
    self.lblTitle.frame = self.status.titleFrame;
    self.lblText.frame = self.status.textFrame;
}

- (void)updateData
{
    News *newsItem =  [self.status getNews];
    NSString *picImage = @"";
    if ([newsItem.imageHref isEqualToString:@""]) {
        picImage = @"";
    } else {
        picImage = [newsItem imageHref];
    }
    self.imagePic.image = [UIImage imageNamed:picImage];
    [self.lblTitle setText:[newsItem title]];
    [self.lblText setText:[newsItem desc]];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
