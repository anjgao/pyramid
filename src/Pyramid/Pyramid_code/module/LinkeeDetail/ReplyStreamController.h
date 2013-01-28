//
//  ReplyStreamController.h
//  Pyramid
//
//  Created by andregao on 13-1-23.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKTableController.h"

@class Json_reply;

@protocol ReplyStreamCtlDelegate <NSObject>
- (void)replyDidSelect:(Json_reply*)reply;
@end

@interface ReplyStreamController : LKTableController
@property id<ReplyStreamCtlDelegate> delegate;
- (id)initWithLinkeeID:(NSNumber*)linkeeID;
@end
