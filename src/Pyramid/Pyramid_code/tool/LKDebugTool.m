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
    LKLog(@"===========  view tree end  ============");
}

#endif