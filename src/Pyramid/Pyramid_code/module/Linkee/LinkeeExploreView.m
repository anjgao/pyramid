//
//  LinkeeExploreView.m
//  Pyramid
//
//  Created by andregao on 13-1-18.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeExploreView.h"
#import "ASIHTTPRequest.h"
#import "ExploreLinkeeResponse.h"

#define LE_CELL_TEXT    250

@interface LinkeeExploreView() <UITableViewDataSource,UITableViewDelegate>
{
    // data
    int                     _curOffset;
    NSMutableArray*         _linkees;
    BOOL                    _allLoad;
    
    // view
    UITableView*            _table;
}
@end

@implementation LinkeeExploreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        _linkees = [NSMutableArray arrayWithCapacity:20];
        
        _table = [[UITableView alloc] initWithFrame:self.bounds];
        _table.dataSource = self;
        _table.delegate = self;
        _table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:_table];
        
        [self requestLE];
    }
    return self;
}

#pragma mark - request data
-(void)requestLE
{
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/explore_linkee/explore/?limit=20&offset=%d", _linkees.count];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:linkkkUrl(urlPath)];
    request.delegate = self;
    request.didFinishSelector = @selector(leLoadFinished:);
    request.didFailSelector = @selector(leLoadFailed:);
    [request startAsynchronous];
}

- (void)leLoadFinished:(ASIHTTPRequest *)request
{
    json2obj(request.responseData, ExploreLinkeeResponse)
    [_linkees addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _allLoad = YES;
    }
    [_table reloadData];
}

- (void)leLoadFailed:(ASIHTTPRequest *)request
{
    LKLog([request responseString]);
    LKLog([[request error] localizedDescription]);
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _linkees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseID = @"linkeeItem";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
        cell = [self createTableCell:reuseID];
    
    [self fillCell:cell data:[_linkees objectAtIndex:indexPath.row]];
    return cell;
}

-(UITableViewCell*)createTableCell:(NSString*)reuseID
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cell.bounds.size.width-20, 0)];
    text.tag = LE_CELL_TEXT;
    text.numberOfLines = 0;
    [cell.contentView addSubview:text];
    
    return cell;
}

-(void)fillCell:(UITableViewCell*)cell data:(Json_object*)data
{
    UILabel* text = (UILabel*)[cell viewWithTag:LE_CELL_TEXT];
    CGRect frame = text.frame;
    frame.size = CGSizeMake(cell.bounds.size.width - 20, 0);
    text.frame = frame;
    text.text = data.content;
    [text sizeToFit];
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = text.frame.size.height + 20;
    cell.frame = cellFrame;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static UITableViewCell* cell = nil;
    if (!cell)
        cell = [self createTableCell:nil];
    [self fillCell:cell data:[_linkees objectAtIndex:indexPath.row]];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !_allLoad && indexPath.row == _linkees.count-1 )
    {
        [self requestLE];
        printViewTree(self.superview);
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
