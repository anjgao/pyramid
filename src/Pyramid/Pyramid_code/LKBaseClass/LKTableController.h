//
//  LKTableController.h
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKViewController.h"
#import "ASIHTTPRequest.h"

@protocol LKTableControllerDelegate <NSObject>
-(void)createCellSubviews:(UITableViewCell*)cell;
-(void)fillCell:(UITableViewCell*)cell data:(id)data index:(NSIndexPath*)index forHeight:(BOOL)bForHeight;
-(NSString*)requestUrlPath:(BOOL)bRefresh;
-(void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh;
@optional
-(void)loadFailed:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh;
-(void)cellItemLoadFinish:(ASIHTTPRequest*)request;
-(void)cellItemLoadFailed:(ASIHTTPRequest*)request;
@end

@interface LKTableController : LKViewController <UITableViewDataSource,UITableViewDelegate,LKTableControllerDelegate>
{
    NSMutableArray *    _data;
    UITableView *       _table;
    BOOL                _bLoadFinish;
}
- (id)initWithCapacity:(uint)capacity;
- (void)requestCellItem:(NSString*)url userInfo:(NSDictionary*)userInfo;
- (void)refresh;
- (UITableView*)getTable;
@end
