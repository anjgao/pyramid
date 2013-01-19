//
//  LinkeeExploreController.m
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeExploreController.h"
#import "ASIHTTPRequest.h"
#import "JsonObj.h"

@interface LinkeeExploreController ()

@end

@implementation LinkeeExploreController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self requestLE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMoreData
{
    [self requestLE];
}

#pragma mark - request data
-(void)requestLE
{
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/explore_linkee/explore/?limit=20&offset=%d", _data.count];
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:linkkkUrl(urlPath)];
    request.delegate = self;
    request.didFinishSelector = @selector(leLoadFinished:);
    request.didFailSelector = @selector(leLoadFailed:);
    [request startAsynchronous];
}

- (void)leLoadFinished:(ASIHTTPRequest *)request
{
    json2obj(request.responseData, ExploreLinkeeResponse)
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
    [_table reloadData];
}

- (void)leLoadFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

#pragma mark - LinkeeStreamCtlDelegate
-(Json_linkee*)getCellLinkee:(id)data
{
    return (Json_linkee*)data;
}

@end
