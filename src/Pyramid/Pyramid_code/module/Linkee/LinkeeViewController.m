//
//  LinkeeViewController.m
//  Pyramid
//
//  Created by andregao on 13-1-16.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeViewController.h"
#import "LinkeeExploreView.h"
#import "LinkeeTopTabView.h"
#import "FriendLinkeeView.h"

@interface LinkeeViewController () <UITableViewDataSource,UITableViewDelegate,LinkeeTopTabViewDelegate>
{
    LinkeeTopTabView * _topTabView;
    LinkeeExploreView * _linkeeExploreView;
    FriendLinkeeView * _friendLinkeeView;
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
    _linkeeExploreView = [[LinkeeExploreView alloc] initWithFrame:frame];
    _friendLinkeeView = [[FriendLinkeeView alloc] initWithFrame:frame];
    [self.view addSubview:_linkeeExploreView];
    
    frame.origin.y = 0;
    frame.size.height = 44;
    _topTabView = [[LinkeeTopTabView alloc] initWithFrame:frame];
    [self.view addSubview:_topTabView];
    _topTabView.delegate = self;
    
    printViewTree(self.view);
}

#pragma mark - LinkeeTopTabViewDelegate
-(void)showExploreLinkee
{
    [self changeViewFrom:_friendLinkeeView to:_linkeeExploreView];
}

-(void)showFriendLinkee
{
    [self changeViewFrom:_linkeeExploreView to:_friendLinkeeView];
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



@end
