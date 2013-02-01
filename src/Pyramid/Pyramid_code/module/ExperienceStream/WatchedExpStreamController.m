//
//  WatchedExpStreamController.m
//  Pyramid
//
//  Created by andregao on 13-1-30.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "WatchedExpStreamController.h"
#import "JsonObj.h"

@interface WatchedExpStreamController ()

@end

@implementation WatchedExpStreamController

-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    NSNumber * start = @2147483647;     // todo news id超过该数值时
    if (_data.count > 0 && !bRefresh) {
        Json_watchedExp* last = (Json_watchedExp*)[_data lastObject];
        start = last.id;
    }
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/watched/?id__lt=%@&limit=20&&order_by=-id&user=%@",start.stringValue,_userID.stringValue];
    
    return urlPath;
}

-(void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    json2obj(request.responseData, WatchedExpStreamResponse)
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
}

#pragma mark - ExpStreamCtlDelegate
- (NSNumber*)getID:(id)item
{
    Json_watchedExp * exp = item;
    return exp.id;
}

- (Json_profile*)getExpProfile:(id)item
{
    Json_watchedExp * exp = item;
    return exp.activity.current_profile;
}
@end
