//
//  TaskCenter.m
//  Pyramid
//
//  Created by andregao on 13-1-16.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "TaskCentre.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "LoginResponse.h"

@implementation TaskCentre

-(void)startup
{
    NSString * name = nil;
    NSString * pw = nil;
    if ( [LK_USER getUserName:&name andPW:&pw] ) {
        [self autoLogin:name pw:pw];
        [LK_UI startup:NO];
    }
    else {
        [LK_UI startup:YES];
    }
}

#pragma mark - autologin
-(void)autoLogin:(NSString*)name pw:(NSString*)pw
{
    ASIFormDataRequest* loginRequest = [ASIFormDataRequest requestWithURL:linkkkUrl(@"/io/login/")];
    loginRequest.delegate = self;
    loginRequest.shouldRedirect = NO;
    loginRequest.didFinishSelector = @selector(autoLoginFinished:);
    loginRequest.didFailSelector = @selector(autoLoginFailed:);
    
    [loginRequest setPostValue:name forKey:@"login"];
    [loginRequest setPostValue:pw forKey:@"password"];
    
    [loginRequest startAsynchronous];
}

- (void)autoLoginFinished:(ASIHTTPRequest *)request
{
    LKLog(request.responseString);
    
    json2obj(request.responseData,LoginResponse)
    
    if ([repObj.status isEqualToString:@"okay"]) {
        [self saveXSRFToken:request.responseCookies];
        LK_USER.userID = repObj.data.user_id;
        [LK_UI autoLoginFinish:YES];
    }
    else if ([repObj.status isEqualToString:@"oops"]) {
        [self logout:repObj.invalidations.__all__[0]];
    }
}

- (void)autoLoginFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

-(void)saveXSRFToken:(NSArray*)cookies
{
    for (NSHTTPCookie* cookie in cookies) {
        if ([cookie.name isEqualToString:@"XSRF-TOKEN"]) {
            LK_USER.xsrfToken = cookie.value;
            break;
        }
    }
}

#pragma mark - logout
- (void)logout:(NSString*)hint
{
    [LK_USER deleteNameAndPW];
    [LK_CONFIG clearSessionCookie];
    printCookies();
    // todo clean user data?
    [self serverLogout];
    
    [LK_UI popLogin:hint];
}

- (void)serverLogout
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:linkkkUrl(@"/logout")];
    request.shouldRedirect = NO;
    request.delegate = self;
    request.didFinishSelector = @selector(logoutRequestFinished:);
    request.didFailSelector = @selector(logoutRequestFailed:);
    [request startAsynchronous];
}

- (void)logoutRequestFinished:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
}

- (void)logoutRequestFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}


@end
