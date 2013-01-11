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

@interface UICentre() <LoginCtlDelegate>

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
    UIViewController* ctl1 = [[UIViewController alloc] init];
    ctl1.view.backgroundColor = [UIColor blackColor];
    ctl1.title = @"1";
    LKNavigationController* nav1 = [[LKNavigationController alloc] initWithRootViewController:ctl1];
    
    // tab 2
    UIViewController* ctl2 = [[UIViewController alloc] init];
    ctl2.view.backgroundColor = [UIColor grayColor];
    ctl2.title = @"2";
    LKNavigationController* nav2 = [[LKNavigationController alloc] initWithRootViewController:ctl2];

    // tab 3
    UIViewController* ctl3 = [[UIViewController alloc] init];
    ctl3.view.backgroundColor = [UIColor brownColor];
    ctl3.title = @"3";
    LKNavigationController* nav3 = [[LKNavigationController alloc] initWithRootViewController:ctl3];

    // tab 4
    UIViewController* ctl4 = [[UIViewController alloc] init];
    ctl4.view.backgroundColor = [UIColor whiteColor];
    ctl4.title = @"4";
    LKNavigationController* nav4 = [[LKNavigationController alloc] initWithRootViewController:ctl4];

    _tabCtl.viewControllers = @[nav1,nav2,nav3,nav4];
    
//    [_tabCtl createCustomBtns];
//    _tabCtl.tabBar.hidden = YES;
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
    [UIView transitionWithView:self.window
            duration:0.5
            options: UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseIn
            animations:^{
                self.window.rootViewController = _tabCtl;
            }
            completion:nil];
}

@end
