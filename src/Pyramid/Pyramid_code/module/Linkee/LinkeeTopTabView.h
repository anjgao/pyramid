//
//  LinkeeTopTabView.h
//  Pyramid
//
//  Created by andregao on 13-1-18.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKView.h"

@protocol LinkeeTopTabViewDelegate <NSObject>
-(void)showExploreLinkee;
-(void)showFriendLinkee;
@end


@interface LinkeeTopTabView : LKView
@property(nonatomic,assign) id delegate;
@end
