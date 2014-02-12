//
//  LKDebugTool.c
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKDebugTool.h"

#ifdef DEBUG

void printViewTreeWithDeep(UIView * curView, int deep, NSMutableString* str)
{
    [str setString:@"-"];
    for (int i = 0; i < deep; i++) {
        [str appendString:@"-"];
    }
    
    CGRect frame = curView.frame;
    [str appendFormat:@" %@ [%.0f,%.0f,%.0f,%.0f]",NSStringFromClass([curView class]),frame.origin.x,frame.origin.y,frame.size.width,frame.size.height];
    LKLog(str);
    
    for (UIView * subview in curView.subviews)
    {
        printViewTreeWithDeep(subview, deep+1, str);
    }
}

void printViewTree(UIView* rootView)
{
    NSMutableString* str = [NSMutableString stringWithCapacity:64];
    LKLog(@"=========== view tree start ============");
    printViewTreeWithDeep(rootView,0,str);
    LKLog(@"===========  view tree end  ============");  // for git test
}

void printCookies(void)
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    LKLog(@"======= cookies ======");
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = cookieStorage.cookies;
    for (NSHTTPCookie * cookie in cookies ) {
        NSString* strDate = [df stringFromDate:cookie.expiresDate];
        NSString * cookieStr = [NSString stringWithFormat:@"%@  %@  %@  %@  %@", cookie.name, cookie.value, strDate,cookie.domain, cookie.path];
        LKLog(cookieStr);
    }
    LKLog(@"=====================");
}

#endif