//
//  ViewController.m
//  News
//
//  Created by Martin on 3/12/15.
//  Copyright (c) 2015 Martin. All rights reserved.
//

#import "ViewController.h"
#import "CJSONDeserializer.h"
#import "NewsItemCell.h"
#import "NewsItemFrame.h"
#import "FootView.h"
#define newsQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define SHOWITEMS 2

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,FootViewDelegate>
@property(nonatomic, retain)IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSArray *newsFrameArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *showFrameArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchJSONData];
    _tableView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.delegate=self;
    _tableView.dataSource = self;
    [self initFootView];
    self.newsFrameArray = [[NSArray alloc]init];
    self.showFrameArray = [[NSArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initFootView {
    CGFloat footbtnHeight = 35.0f;
    CGFloat footcontentPaddingLeft = 8.0f;
    CGFloat footcontentPaddingTop = 2.0f;
    FootView *footbutton = [[FootView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, footbtnHeight) withButtonFrame:CGRectMake(footcontentPaddingLeft,footcontentPaddingTop , (self.view.frame.size.width-2*footcontentPaddingLeft), (footbtnHeight-2*footcontentPaddingTop))];
    footbutton.delegate = self;
    _tableView.tableFooterView = footbutton;
    [footbutton release];
}

- (void)initDataSource {
    self.index = 0+ SHOWITEMS;
    NSArray *sliceArray =[[NSArray alloc] initWithArray:[self.newsFrameArray subarrayWithRange:NSMakeRange(0, self.index)]];
    self.showFrameArray =sliceArray;
    [sliceArray release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showFrameArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsItemCell * cell = [NewsItemCell NewsWithCell:tableView];
    NewsItemFrame *newItem = _showFrameArray[indexPath.row];
    cell.status = newItem;
    return cell;
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsItemFrame *itemFrame =_newsFrameArray[indexPath.row];
    return itemFrame.cellHeight;
}

#pragma mark - Table View header delegate
- (void)updateDate:(FootView *)footview
{
    if ((self.index + SHOWITEMS) >=([_newsFrameArray count]-1)) {
        self.index =([_newsFrameArray count]-1);
    } else {
        self.index += SHOWITEMS;
    }
    NSArray *sliceArray = [[NSArray alloc] initWithArray: [_newsFrameArray subarrayWithRange:NSMakeRange(0, self.index)]];
    self.showFrameArray = sliceArray;
    [sliceArray release];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JSON data
- (void)fetchJSONData{
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"]];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
    
        _receivedData = [[NSMutableData alloc]init];
        [connection start];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"get the whole response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}
    
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSISOLatin1StringEncoding
    NSError *error = nil;
    NSString *receivedString = [[NSString alloc] initWithData:_receivedData encoding:NSISOLatin1StringEncoding];
    NSData *jsonData = [receivedString dataUsingEncoding:NSUTF8StringEncoding];
    [receivedString release];
    NSDictionary *factsDict =[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    NSString *articalTitle = [factsDict objectForKey:@"title"];
    NSArray *newsArray = [factsDict objectForKey:@"rows"];
    NSMutableArray *framesArray =[[NSMutableArray alloc]init];
    for (NSDictionary *newsitem in newsArray) {
        if ([newsitem objectForKey:@"title"] !=[NSNull null]) {
            News *news = [[News alloc]initWithDict:newsitem];
            NewsItemFrame *itemFrame = [[NewsItemFrame alloc]initFrameWithNews:news withViewFrame:self.view.bounds];
            [news release];
            [framesArray addObject:itemFrame ];
            [itemFrame release];
        }
        
    }
    self.newsFrameArray = framesArray;
    [framesArray release];
    [self initDataSource];
    [self.tableView reloadData];
    self.navigationItem.title = articalTitle;
    [(FootView*)_tableView.tableFooterView stopAnimation];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                    message:@"Network connection error"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [(FootView*)_tableView.tableFooterView stopAnimation];
}

-(void)dealloc
{
    [_receivedData release];
    _receivedData =nil;
    [_newsFrameArray release];
    _newsFrameArray = nil;
    [_showFrameArray release];
    _showFrameArray = nil;
    [super dealloc];
}
@end
