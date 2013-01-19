//
//  LinkeeNewsController.m
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeNewsController.h"
#import "ASIHTTPRequest.h"
#import "JsonObj.h"

@interface LinkeeNewsController ()

@end

@implementation LinkeeNewsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self requestNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMoreData
{
    [self requestNews];
}

#pragma mark - request data
-(void)requestNews
{
    //    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/explore_linkee/explore/?limit=20&offset=%d", _data.count];
    NSNumber * start = @2147483647;
    if (_data.count > 0 ) {
        Json_news* last = (Json_news*)[_data lastObject];
        start = last.id;
    }
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/news/?id__lt=%@&limit=20&order_by=-id",start.stringValue];
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:linkkkUrl(urlPath)];
    request.delegate = self;
    request.didFinishSelector = @selector(newsLoadFinished:);
    request.didFailSelector = @selector(newsLoadFailed:);
    [request startAsynchronous];
}

- (void)newsLoadFinished:(ASIHTTPRequest *)request
{
    json2obj(request.responseData, NewsResponse)
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
    [_table reloadData];
}

- (void)newsLoadFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

#pragma mark - LinkeeStreamCtlDelegate
-(Json_linkee*)getCellLinkee:(id)data
{
    return ((Json_news*)data).linkee;
}

@end
