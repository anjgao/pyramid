//
//  LKTableController.m
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKTableController.h"
#import "ASINetworkQueue.h"
#import "EGORefreshTableHeaderView.h"

@interface LKTableController() <EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIActivityIndicatorView * _footer;
    UITableViewCell * _cellForH;
    
    BOOL _bRefreshRequest;
    ASIHTTPRequest * _curRequest;
    ASINetworkQueue * _queue;
}
@end

@implementation LKTableController
- (id)initWithCapacity:(uint)capacity
{
    self = [super init];
    
    _data = [NSMutableArray arrayWithCapacity:capacity];
    
    _queue = [ASINetworkQueue queue];
    _queue.maxConcurrentOperationCount = 6;
    _queue.delegate = self;
    _queue.requestDidFinishSelector = @selector(cellItemLoadFinish:);
    _queue.requestDidFailSelector = @selector(cellItemLoadFailed:);
    _queue.shouldCancelAllRequestsOnFailure = NO;
    [_queue go];
        
    return self;
}

- (void)dealloc
{
    [_curRequest clearDelegatesAndCancel];
    [_queue reset];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    if (nil == _table) {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds];
        _table.dataSource = self;
        _table.delegate = self;
        _table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_table];
    }
    
    if (nil == _footer) {
        _footer = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _footer.frame = CGRectMake(0, 0, _table.bounds.size.width, 60);
        _footer.hidesWhenStopped = YES;
        _table.tableFooterView = _footer;
    }
    
    if (nil == _refreshHeaderView) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - _table.bounds.size.height, self.view.frame.size.width, _table.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[_table addSubview:_refreshHeaderView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh
{
    [_table setContentOffset:CGPointMake(0, -65) animated:NO];
    [_refreshHeaderView egoRefreshScrollViewDidScroll:_table];
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:_table];
}

-(UITableView*)getTable
{
    return _table;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseID = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
        cell = [self createTableCell:reuseID];
    
    [self fillCell:cell data:[_data objectAtIndex:indexPath.row] index:indexPath forHeight:NO];
    return cell;
}

-(UITableViewCell*)createTableCell:(NSString*)reuseID
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    [self createCellSubviews:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // todo 存储高度、不每次重复计算
    if (!_cellForH)
        _cellForH = [self createTableCell:nil];
    [self fillCell:_cellForH data:[_data objectAtIndex:indexPath.row] index:indexPath forHeight:YES];
    return _cellForH.frame.size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !_bLoadFinish && indexPath.row == _data.count-1 )
    {
        [self requestData:NO];
    }
}

#pragma mark - request data
-(void)requestData:(BOOL)bRefresh
{
    if (_curRequest)
        return;
    
    NSString* urlPath = [self requestUrlPath:bRefresh];
    if (nil == urlPath)
        return;
    
    _curRequest = [ASIHTTPRequest requestWithURL:linkkkUrl(urlPath)];
    _curRequest.delegate = self;
    _curRequest.didFinishSelector = @selector(dataLoadFinished:);
    _curRequest.didFailSelector = @selector(dataLoadFailed:);
    [_curRequest startAsynchronous];
    
    _bRefreshRequest = bRefresh;
    if (!bRefresh)
        [_footer startAnimating];
}

- (void)dataLoadFinished:(ASIHTTPRequest *)request
{
    _curRequest = nil;
    
    if (_bRefreshRequest) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_table];
        [_data removeAllObjects];
        [self loadSuccess:request bRefresh:YES];
        [_table reloadData];
    }
    else {
        [_footer stopAnimating];
        
        uint old = _data.count;
        [self loadSuccess:request bRefresh:NO];
        uint new = _data.count;
        
        NSMutableArray * insertArr = [NSMutableArray arrayWithCapacity:20];
        for (uint i = old; i < new; i++) {
            [insertArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [_table insertRowsAtIndexPaths:insertArr withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)dataLoadFailed:(ASIHTTPRequest *)request
{
    _curRequest = nil;
    
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
    
    if (_bRefreshRequest)
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_table];
    else
        [_footer stopAnimating];
    
    [self loadFailed:request bRefresh:_bRefreshRequest];
}

#pragma mark - cell item
- (void)requestCellItem:(NSString*)url userInfo:(NSDictionary*)userInfo
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    request.userInfo = userInfo;
    [_queue addOperation:request];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self requestData:YES];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return (_curRequest != nil);
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date];	
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - LKTableControllerDelegate
-(void)createCellSubviews:(UITableViewCell*)cell
{
    
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data index:(NSIndexPath *)index forHeight:(BOOL)bForHeight
{
    
}

-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    return nil;
}

-(void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    
}

-(void)loadFailed:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    
}

-(void)cellItemLoadFinish:(ASIHTTPRequest*)request
{
    
}

-(void)cellItemLoadFailed:(ASIHTTPRequest*)request
{
    
}

@end
