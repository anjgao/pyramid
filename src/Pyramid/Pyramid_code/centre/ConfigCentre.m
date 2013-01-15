//
//  ConfigCentre.m
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ConfigCentre.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIHTTPRequestConfig.h"

@implementation ConfigCentre

-(id)init
{
    self = [super init];
    
    // for debug
    printCookies();
    
    // ASIHTTPRequest
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    return self;
}

-(void)cleanSessionCookie
{
    [ASIHTTPRequest clearSession];
    
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = cookieStorage.cookies;
    NSMutableArray* delCookies = [NSMutableArray arrayWithCapacity:4];
    for ( NSHTTPCookie * cookie in cookies ) {
        if ( [cookie.name isEqualToString:@"sessionid"] ) {
            [delCookies addObject:cookie];
        }
        else if ( [cookie.name isEqualToString:@"XSRF-TOKEN"] ) {
            [delCookies addObject:cookie];
        }
    }
    for ( NSHTTPCookie * cookie in delCookies ) {
        [cookieStorage deleteCookie:cookie];
    }
}

@end
