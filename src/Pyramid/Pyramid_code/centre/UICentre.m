//
//  UICentre.m
//  Pyramid
//
//  Created by andregao on 13-1-10.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKTabBarController.h"
#import "LKNavigationController.h"
#import "LoginController.h"
#import "PersonalController.h"
#import "SettingController.h"

@interface UICentre() <LoginCtlDelegate>
{
    PersonalController*    _personalController;
}

@end

@implementation UICentre

-(id)initWithWindow:(UIWindow *) window
{
    self = [super init];
    
    self.window = window;
    [self initTabs];
    [self popLoginView];
    
    return self;
}

#pragma mark - inner method
-(void)initTabs
{
    _tabCtl = [[LKTabBarController alloc] init];

    // tab 1
    _personalController = [[PersonalController alloc] init];
    LKNavigationController* nav1 = [[LKNavigationController alloc] initWithRootViewController:_personalController];
    
    // tab 2
    UIViewController* ctl2 = [[UIViewController alloc] init];
    ctl2.view.backgroundColor = [UIColor blackColor];
    ctl2.title = @"2";
    LKNavigationController* nav2 = [[LKNavigationController alloc] initWithRootViewController:ctl2];

    // tab 3
    UIViewController* ctl3 = [[UIViewController alloc] init];
    ctl3.view.backgroundColor = [UIColor brownColor];
    ctl3.title = @"3";
    LKNavigationController* nav3 = [[LKNavigationController alloc] initWithRootViewController:ctl3];

    // tab 4
    SettingController* sc = [[SettingController alloc] init];
    LKNavigationController* nav4 = [[LKNavigationController alloc] initWithRootViewController:sc];

    _tabCtl.viewControllers = @[nav1,nav2,nav3,nav4];
    
//    [_tabCtl createCustomBtns];
//    _tabCtl.tabBar.hidden = YES;
//    self.window.rootViewController = _tabCtl;   // layout main view
}

-(void)popLoginView
{
    LoginController* loginCtl = [[LoginController alloc] init];
    loginCtl.delegate = self;
    self.window.rootViewController = loginCtl;
}

#pragma mark - LoginDelegate
-(void)loginSuccess
{
    self.window.rootViewController = _tabCtl;
    [UIView transitionWithView:self.window
            duration:0.3
            options: UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseOut
            animations:nil 
            completion:nil];
    
    [_personalController showProfileWithID:LK_USER.userID];
}

@end
