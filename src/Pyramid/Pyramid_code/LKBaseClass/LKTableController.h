//
//  LKTableController.h
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKViewController.h"

@protocol LKTableControllerDelegate <NSObject>
-(void)createCellSubviews:(UITableViewCell*)cell;
-(void)fillCell:(UITableViewCell*)cell data:(id)data;
-(void)loadMoreData;
@end

@interface LKTableController : LKViewController <UITableViewDataSource,UITableViewDelegate,LKTableControllerDelegate>
{
    NSMutableArray *    _data;
    UITableView *       _table;
    BOOL                _bLoadFinish;
}
- (id)initWithCapacity:(uint)capacity;
@end
