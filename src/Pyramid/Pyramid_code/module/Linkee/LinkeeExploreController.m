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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request data
-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    uint offset = 0;
    if (!bRefresh)
        offset = _data.count;
    return [NSString stringWithFormat:@"/api/alpha/explore_linkee/explore/?limit=20&offset=%d", offset];
}

- (void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    json2obj(request.responseData, ExploreLinkeeResponse)    
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
}

#pragma mark - LinkeeStreamCtlDelegate
-(Json_linkee*)getCellLinkee:(id)data
{
    return (Json_linkee*)data;
}

@end
