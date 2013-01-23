//
//  ProfileLinkeeController.m
//  Pyramid
//
//  Created by andregao on 13-1-23.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ProfileLinkeeController.h"
#import "JsonObj.h"

@interface ProfileLinkeeController ()

@end

@implementation ProfileLinkeeController

-(UITableView*)getTable
{
    return _table;
}

#pragma mark - request data
-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    if (_targetID == nil)
        return nil;
    
    NSNumber * start = @2147483647;     // todo news id超过该数值时
    if (_data.count > 0 && !bRefresh) {
        Json_news* last = (Json_news*)[_data lastObject];
        start = last.id;
    }
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/timeline/?id__lt=%@&limit=20&order_by=-id&user=%@",start.stringValue,[_targetID stringValue]];
    
    return urlPath;
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
