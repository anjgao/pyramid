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
#import "LinkeeViewController.h"

@interface UICentre()
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
    
    return self;
}

-(void)autoLoginFinish:(BOOL)bSuccess;
{
    if (bSuccess) {
        [_personalController showProfileWithID:LK_USER.userID];
    }
}

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

#pragma mark - inner method
-(void)initTabs
{
    _tabCtl = [[LKTabBarController alloc] init];

    // tab 1
    _personalController = [[PersonalController alloc] init];
    LKNavigationController* nav1 = [[LKNavigationController alloc] initWithRootViewController:_personalController];
    
    // tab 2
    LinkeeViewController* ctl2 = [[LinkeeViewController alloc] init];
    LKNavigationController* nav2 = [[LKNavigationController alloc] initWithRootViewController:ctl2];
    nav2.navigationBarHidden = YES;
    
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

-(void)startup:(BOOL)bLogin
{
    if (bLogin) {
        LoginController* loginCtl = [[LoginController alloc] init];
        self.window.rootViewController = loginCtl;
    }
    else {
        self.window.rootViewController = _tabCtl;
    }
}

-(void)popLogin:(NSString*)hint
{
    LoginController* loginCtl = [[LoginController alloc] init];
    loginCtl.hint = hint;
    self.window.rootViewController = loginCtl;
    
    [UIView transitionWithView:self.window
                      duration:0.3
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations:nil
                    completion:nil];
}

@end
