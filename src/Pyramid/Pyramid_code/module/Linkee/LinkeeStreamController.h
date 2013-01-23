//
//  LinkeeStreamController.h
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKTableController.h"

@class Json_linkee;

@protocol  LinkeeStreamCtlDelegate<NSObject>
-(Json_linkee*)getCellLinkee:(id)data;
@end

@interface LinkeeStreamController : LKTableController <LinkeeStreamCtlDelegate>
@property(nonatomic,assign)UINavigationController * navCtl;
@end
