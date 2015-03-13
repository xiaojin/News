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
@property(nonatomic, retain)IBOutlet UILabel *lblTitle;
@property(nonatomic, retain)IBOutlet UILabel *lblText;
@property(nonatomic, retain)IBOutlet UIImageView *imagePic;
@end

@implementation NewsItemCell

+ (instancetype) NewsWithCell:(UITableView *)tableview;
{
    static NSString *identity =@"news";
    NewsItemCell * cell = [tableview dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[[NewsItemCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity] autorelease];
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
        [lblTitle release];
        
        UILabel *lblText = [[UILabel alloc]init];
        [lblText setFont:NewsTextFont];
        [lblText setNumberOfLines:0];
        [self addSubview:lblText];
        self.lblText = lblText;
        [lblText release];

        
        UIImageView *imagePic = [[UIImageView alloc] init];
        [self addSubview:imagePic];
        self.imagePic = imagePic;
        [imagePic release];
        
    }
    return  self;
}

- (void)setStatus:(NewsItemFrame *)status
{
    if (_status !=status) {
        [_status release];
        _status = [status retain];
        [self updateFrame];
        [self updateData];
    }

}

- (void)updateFrame
{
    _imagePic.frame = _status.pictureFrame;
    _lblTitle.frame = _status.titleFrame;
    _lblText.frame = _status.textFrame;
}

- (void)updateData
{
    News *newsItem =  [_status getNews];
    _imagePic.image = [UIImage imageNamed:@"default.jpg"];
    if (![newsItem.imageHref isEqualToString:@""]) {
        dispatch_queue_t q =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(q , ^{

            [self performSelectorInBackground:@selector(showImages:) withObject:newsItem.imageHref];
        });
    }
    
    [_lblTitle setText:[newsItem title]];
    [_lblText setText:[newsItem desc]];
}
- (void)showImages:(NSString*)imageURL
{
    NSError *error = nil;
    NSData *imagedata =  [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL] options:NSDataReadingMappedAlways error:&error];
    if (error==nil) {
        UIImage *img = [[UIImage alloc] initWithData:imagedata];
        _imagePic.image = img;
        [img release];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_status release];
    _status = nil;
    [super dealloc];
}

@end
