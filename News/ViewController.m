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
#define newsQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property(nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSArray *newsFrameArray;
@property (nonatomic, strong) NSString *articalTitle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readJSONdata];
    _tableView.frame = self.view.bounds;
    _tableView.delegate=self;
    _tableView.dataSource = self;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsFrameArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsItemCell * cell = [NewsItemCell NewsWithCell:tableView];
    cell.status = self.newsFrameArray[indexPath.row];
    return cell;
}

#pragma mark - tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsItemFrame *itemFrame =self.newsFrameArray[indexPath.row];
    return itemFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect statusBarWindowRect = [self.view.window convertRect:statusBarFrame fromWindow: nil];
    
    CGRect statusBarViewRect = [self.view convertRect:statusBarWindowRect fromView: nil];
    return statusBarViewRect.size.height;
}



#pragma mark - JSON data

- (void)readJSONdata {
     NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"facts.json" ofType:nil];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict =[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    self.articalTitle = [dict objectForKey:@"title"];
    NSArray *newsArray = [dict objectForKey:@"rows"];
    NSMutableArray *framesArray =[NSMutableArray array];
    for (NSDictionary *newsitem in newsArray) {
        if ([newsitem objectForKey:@"title"] !=[NSNull null]) {
            News *news = [[News alloc]initWithDict:newsitem];
            NewsItemFrame *itemFrame = [[NewsItemFrame alloc]initFrameWithNews:news withViewFrame:self.view.bounds];
            [framesArray addObject:itemFrame ];
        }

    }
    _newsFrameArray = framesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchJSONData{
   // dispatch_async(newsQueue, ^{
//        NSError *error = nil;
//        NSURLResponse *response = nil;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/746330/facts.json"]];
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
            _receivedData = [[NSMutableData alloc]init];
        [connection start];
//        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//        NSDictionary *dictionary =[[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&error];
//        NSLog(@"Title, %@",[dictionary objectForKey:@"title"]);
        
   // });
    

}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge]; [challenge.sender cancelAuthenticationChallenge:challenge];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"get the whole response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"get the data");
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{           NSError *error = nil;
//            NSDictionary *dictionary =[[CJSONDeserializer deserializer] deserializeAsDictionary:receivedData error:&error];
    NSString *charlieSendString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",charlieSendString);
    
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:_receivedData //1
                          
                          options:kNilOptions
                          error:&error];
    
//    NSLog(@"loans: %@", latestLoans); //3
//            NSLog(@"Title, %@",[dictionary objectForKey:@"title"]);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error");
}

@end
