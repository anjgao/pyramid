//
//  LKAppDelegate.h
//  Pyramid
//
//  Created by andregao on 13-1-10.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICentre;
@class ConfigCentre;
@class UserCentre;

@interface LKAppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UICentre * objUICentre;
@property (retain, nonatomic) ConfigCentre * objConfigCentre;
@property (retain, nonatomic) UserCentre * objUserCentre;

@property (retain, nonatomic) UIWindow * window;

@end
