//
//  ReplyStreamController.m
//  Pyramid
//
//  Created by andregao on 13-1-23.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ReplyStreamController.h"
#import "JsonObj.h"

#define CELL_CONTENT 500
#define CELL_NAME 501
#define CELL_HEAD 502
#define CELL_TIME 503

@interface ReplyStreamController ()
{
    NSNumber * _linkeeID;
}
@end

@implementation ReplyStreamController

- (id)initWithLinkeeID:(NSNumber*)linkeeID
{
    self = [super initWithCapacity:20];
    _linkeeID = linkeeID;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LKTableControllerDelegate
-(void)createCellSubviews:(UITableViewCell*)cell
{
    int w = cell.bounds.size.width;
    
    UIImageView * head = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    head.tag = CELL_HEAD;
    [cell.contentView addSubview:head];
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, w-70-10, 20)];
    name.tag = CELL_NAME;
    [cell.contentView addSubview:name];
    
    UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(70, 45, w-70-10, 15)];
    time.tag = CELL_TIME;
    time.textColor = [UIColor grayColor];
    time.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:time];
    
    UILabel * content = [[UILabel alloc] init];
    content.tag = CELL_CONTENT;
    content.font = [UIFont systemFontOfSize:14];
    content.numberOfLines = 0;
    [cell.contentView addSubview:content];
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data index:(NSIndexPath *)index forHeight:(BOOL)bForHeight
{
    Json_reply * reply = (Json_reply*)data;

    if (!bForHeight) {
        UILabel * name = (UILabel*)[cell.contentView viewWithTag:CELL_NAME];
        name.text = reply.author.username;
        
        UILabel * time = (UILabel*)[cell.contentView viewWithTag:CELL_TIME];
        time.text = [LK_CONFIG dateDisplayString:reply.created];

        UIImageView * head = (UIImageView*)[cell.contentView viewWithTag:CELL_HEAD];
        head.image = nil;
        NSDictionary * imgDic = @{@"index":index};
        [self requestCellItem:reply.author.medium_avatar userInfo:imgDic];
    }
    
    int w = cell.bounds.size.width;
    UILabel * content = (UILabel*)[cell.contentView viewWithTag:CELL_CONTENT];
    content.frame = CGRectMake(10, 70, w-20, 0);
    content.text = reply.content;
    [content sizeToFit];
    
    CGRect cellB = cell.bounds;
    cellB.size.height = content.bounds.size.height + 80;
    cell.bounds = cellB;
}

-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    NSNumber * start = @2147483647;     // todo news id超过该数值时
    if (_data.count > 0 && !bRefresh) {
        Json_reply* last = (Json_reply*)[_data lastObject];
        start = last.id;
    }
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/reply_stream/?id__lt=%@&limit=20&linkee=%@&order_by=-id",start.stringValue,_linkeeID];
    
    return urlPath;
}

-(void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    LKLog(request.responseString);
    
    json2obj(request.responseData, ReplyStreamResponse)
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
}

-(void)loadFailed:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    
}

-(void)cellItemLoadFinish:(ASIHTTPRequest*)request
{
    NSIndexPath * index = [request.userInfo objectForKey:@"index"];
    
    UITableViewCell* cell = [_table cellForRowAtIndexPath:index];
    if (cell) {
        UIImageView * img = (UIImageView*)[cell.contentView viewWithTag:CELL_HEAD];
        img.image = [UIImage imageWithData:request.responseData];
    }
}

-(void)cellItemLoadFailed:(ASIHTTPRequest*)request
{
    
}


@end
