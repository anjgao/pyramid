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

#ifdef PonyD
#import <PonyDebugger/PonyDebugger.h>
#endif

@implementation ConfigCentre

-(id)init
{
    self = [super init];

    // ponyD
#ifdef PonyD
    [self setupPonyDebugger];
#endif
    
    // for debug
    printCookies();
    
    // ASIHTTPRequest
    ASIDownloadCache* downLoadCache = [ASIDownloadCache sharedCache];
    downLoadCache.defaultCachePolicy = ASIAskServerIfModifiedWhenStaleCachePolicy;
    [ASIHTTPRequest setDefaultCache:downLoadCache];
    
    return self;
}

#ifdef PonyD
-(void)setupPonyDebugger
{
    PDDebugger *debugger = [PDDebugger defaultInstance];
    
    // Enable Network debugging, and automatically track network traffic that comes through any classes that NSURLConnectionDelegate methods.
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    // Enable Core Data debugging, and broadcast the main managed object context.
    //    [debugger enableCoreDataDebugging];
    //    [debugger addManagedObjectContext:self.managedObjectContext withName:@"Twitter Test MOC"];
    
    // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
    // Choose a few UIView key paths to display as attributes of the dom nodes
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque"]];
    
    // Connect to a specific host
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
}
#endif

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
