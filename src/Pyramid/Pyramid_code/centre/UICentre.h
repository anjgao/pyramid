//
//  UICentre.h
//  Pyramid
//
//  Created by andregao on 13-1-10.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKTabBarController;
@class LoginController;

@interface UICentre : NSObject

@property(retain,nonatomic)     LKTabBarController * tabCtl;
@property(assign,nonatomic)     UIWindow * window;

-(id)initWithWindow:(UIWindow *) window;

-(void)startup:(BOOL)bLogin;                // call from taskCentre
-(void)popLogin:(NSString*)hint;            // call from taskCentre
-(void)autoLoginFinish:(BOOL)bSuccess;      // call from taskCentre
-(void)loginSuccess;                        // call from LoginController

@end
