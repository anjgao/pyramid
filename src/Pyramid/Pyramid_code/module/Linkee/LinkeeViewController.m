//
//  LinkeeViewController.m
//  Pyramid
//
//  Created by andregao on 13-1-16.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeViewController.h"
#import "LinkeeTopTabView.h"
#import "LinkeeExploreController.h"
#import "LinkeeNewsController.h"

@interface LinkeeViewController () <UITableViewDataSource,UITableViewDelegate,LinkeeTopTabViewDelegate>
{
    LinkeeTopTabView * _topTabView;
    LinkeeExploreController * _linkeeExploreCtl;
    LinkeeNewsController * _friendLinkeeCtl;
}
@end

@implementation LinkeeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = self.view.bounds;
    frame.size.height -= 44;
    frame.origin.y += 44;
    _linkeeExploreCtl = [[LinkeeExploreController alloc] initWithCapacity:20];
    _friendLinkeeCtl = [[LinkeeNewsController alloc] initWithCapacity:20];
    _linkeeExploreCtl.navCtl = self.navigationController;
    _friendLinkeeCtl.navCtl = self.navigationController;
    
    _linkeeExploreCtl.view.frame = frame;
    [self.view addSubview:_linkeeExploreCtl.view];
    
    frame.origin.y = 0;
    frame.size.height = 44;
    _topTabView = [[LinkeeTopTabView alloc] initWithFrame:frame];
    [self.view addSubview:_topTabView];
    _topTabView.delegate = self;
}

#pragma mark - LinkeeTopTabViewDelegate
-(void)showExploreLinkee
{
    [self changeViewFrom:_friendLinkeeCtl.view to:_linkeeExploreCtl.view];
}

-(void)showFriendLinkee
{
    [self changeViewFrom:_linkeeExploreCtl.view to:_friendLinkeeCtl.view];
}

-(void)changeViewFrom:(UIView*)from to:(UIView*)to
{
    if (from.superview) {
        [from removeFromSuperview];
        to.frame = from.frame;
        [self.view addSubview:to];
        [self.view bringSubviewToFront:_topTabView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
        [navigationController setNavigationBarHidden:YES animated:YES];
    else
        [navigationController setNavigationBarHidden:NO animated:YES];
}

@end
