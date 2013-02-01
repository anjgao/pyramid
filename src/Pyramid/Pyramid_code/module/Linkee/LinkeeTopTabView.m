//
//  LinkeeTopTabView.m
//  Pyramid
//
//  Created by andregao on 13-1-18.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeTopTabView.h"

@interface LinkeeTopTabView()
{
    UIButton * _exploreBtn;
    UIButton * _friendBtn;
}
@end

@implementation LinkeeTopTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UICOLOR(229, 229, 229);
        
        _exploreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _exploreBtn.frame = CGRectMake(0, 2, 160, 40);
        [_exploreBtn setTitle:LKString(exploreLinkee) forState:UIControlStateNormal];
        [_exploreBtn addTarget:self action:@selector(tabBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_exploreBtn];
        
        _friendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _friendBtn.frame = CGRectMake(160, 2, 160, 40);
        [_friendBtn setTitle:LKString(friendLinkee) forState:UIControlStateNormal];
        [_friendBtn addTarget:self action:@selector(tabBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_friendBtn];
    }
    return self;
}

-(void)tabBtnPressed:(UIButton*)btn
{
    if (btn == _exploreBtn) {
        _exploreBtn.selected = YES;
        _friendBtn.selected = NO;
        [_delegate showExploreLinkee];
    }
    else if(btn == _friendBtn) {
        _friendBtn.selected = YES;
        _exploreBtn.selected = NO;
        [_delegate showFriendLinkee];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
