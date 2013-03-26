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
#import "NewLinkeeController.h"

@interface UICentre() <UITabBarControllerDelegate>
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
        [_personalController setUserID:LK_USER.userID];
    }
}

-(void)loginSuccess
{
    self.window.rootViewController = _tabCtl;
    
    [UIView transitionWithView:self.window
                      duration:0.3
                       options: UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseOut
                    animations:nil
                    completion:nil];
    
    [_personalController setUserID:LK_USER.userID];
}

#pragma mark - inner method
-(void)initTabs
{
    _tabCtl = [[LKTabBarController alloc] init];
    _tabCtl.delegate = self;
    UITabBar * tabBar = _tabCtl.tabBar;    
    tabBar.backgroundImage = [LK_CONFIG linkeeBg];
//    tabBar.tintColor = [UIColor whiteColor];
//    tabBar.selectionIndicatorImage = [UIImage imageNamed:@"icon"];

    // tab 1
    LinkeeViewController* ctl1 = [[LinkeeViewController alloc] init];
    LKNavigationController* nav1 = [[LKNavigationController alloc] initWithRootViewController:ctl1];
    nav1.navigationBarHidden = YES;
    nav1.delegate = nav1;
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"linkee" image:nil tag:1];
    
    // tab 3
    UIViewController * nav2 = [[UIViewController alloc] init];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"message" image:nil tag:2];
    
    // tab 2
    _personalController = [[PersonalController alloc] init];
    LKNavigationController* nav3 = [[LKNavigationController alloc] initWithRootViewController:_personalController];
    nav3.navigationBarHidden = YES;
    nav3.delegate = nav3;
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"me" image:nil tag:3];

    // tab 4
    SettingController* sc = [[SettingController alloc] init];
    LKNavigationController* nav4 = [[LKNavigationController alloc] initWithRootViewController:sc];
    nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"setting" image:nil tag:4];
    
    // for btn
    UIViewController * btnCtl = [[UIViewController alloc] init];
    btnCtl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"new" image:nil tag:5];

    // set controllers
    _tabCtl.viewControllers = @[nav1,nav2,btnCtl,nav3,nav4];
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

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController.tabBarItem.tag == 5){
        NewLinkeeController * sendLinkeeCtl = [[NewLinkeeController alloc] init];
        LKNavigationController* sendLinkeeNav = [[LKNavigationController alloc] initWithRootViewController:sendLinkeeCtl];
        [_tabCtl presentModalViewController:sendLinkeeNav animated:YES];
        return NO;
    }
    else {
        return YES;
    }
}

@end
