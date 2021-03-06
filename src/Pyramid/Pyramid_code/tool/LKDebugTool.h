//
//  LKDebugTool.h
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#ifndef Pyramid_LKDebugTool_h
#define Pyramid_LKDebugTool_h

// log
#ifdef DEBUG
#define LKLog(format, ...) NSLog(@"%@",[NSString stringWithFormat:@"%@",format, ## __VA_ARGS__])
#else
#define LKLog(format, ...)
#endif

// print view tree
#ifdef DEBUG
void printViewTree(UIView*);
#else
#define printViewTree(view)
#endif

// print sharedHTTPCookieStorage cookies
#ifdef DEBUG
void printCookies(void);
#else
#define printCookies()
#endif


#endif
