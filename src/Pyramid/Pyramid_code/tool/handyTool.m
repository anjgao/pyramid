//
//  handyTool.m
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "handyTool.h"

NSURL* linkkkUrl(NSString* urlPath)
{
//    return [NSURL URLWithString:[@"http://0.0.0.0:8000" stringByAppendingString:urlPath]];

    return [NSURL URLWithString:[@"http://www.linkkk.com" stringByAppendingString:urlPath]];
}

UIImage* scaleImage(UIImage* image,CGSize newSize)
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

void showHUDTip(MBProgressHUD* hud,NSString* text)
{
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.dimBackground = NO;
    [hud.superview bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2];

}
