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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request data
-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    NSNumber * start = @2147483647;     // todo news id超过该数值时
    if (_data.count > 0 && !bRefresh) {
        Json_news* last = (Json_news*)[_data lastObject];
        start = last.id;
    }
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/news/?id__lt=%@&limit=20&order_by=-id",start.stringValue];
    
    return urlPath;
}

- (void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    json2obj(request.responseData, NewsResponse)
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
}

#pragma mark - LinkeeStreamCtlDelegate
-(Json_linkee*)getCellLinkee:(id)data
{
    return ((Json_news*)data).linkee;
}

@end
