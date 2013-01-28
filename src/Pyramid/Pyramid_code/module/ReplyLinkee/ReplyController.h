//
//  ReplyController.h
//  Pyramid
//
//  Created by andregao on 13-1-26.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKViewController.h"

@class Json_linkee;
@class Json_reply;

@protocol ReplyCtlDelegate <NSObject>
-(void)replySuccess;
@end

@interface ReplyController : LKViewController
@property(nonatomic,assign) id<ReplyCtlDelegate> delegate;
- (id)initWithLinkee:(Json_linkee*)linkee reply:(Json_reply*)reply isRelinkee:(BOOL)bRelinkee;
@end
