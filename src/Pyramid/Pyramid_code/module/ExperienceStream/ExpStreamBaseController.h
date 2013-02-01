//
//  ExpStreamBaseController.h
//  Pyramid
//
//  Created by andregao on 13-1-30.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKTableController.h"

@class Json_profile;

@protocol ExpStreamCtlDelegate <NSObject>
- (NSNumber*)getID:(id)item;
- (Json_profile*)getExpProfile:(id)item;
@end

@interface ExpStreamBaseController : LKTableController <ExpStreamCtlDelegate>
{
    NSNumber * _userID;
}
- (id)initWithUserID:(NSNumber*)userID;
@end
