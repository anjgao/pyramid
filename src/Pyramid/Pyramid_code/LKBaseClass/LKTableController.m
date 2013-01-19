//
//  LKTableController.m
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKTableController.h"

@implementation LKTableController
- (id)initWithCapacity:(uint)capacity
{
    self = [super init];
    
    _data = [NSMutableArray arrayWithCapacity:capacity];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _table = [[UITableView alloc] initWithFrame:self.view.bounds];
    _table.dataSource = self;
    _table.delegate = self;
    _table.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _table = nil;
    _bLoadFinish = NO;
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
    
    [self fillCell:cell data:[_data objectAtIndex:indexPath.row]];
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
    static UITableViewCell* cell = nil;
    if (!cell)
        cell = [self createTableCell:nil];
    [self fillCell:cell data:[_data objectAtIndex:indexPath.row]];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !_bLoadFinish && indexPath.row == _data.count-1 )
    {
        [self loadMoreData];
    }
}

#pragma mark - LKTableControllerDelegate
-(void)createCellSubviews:(UITableViewCell*)cell
{
    
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data
{
    
}

-(void)loadMoreData
{
    
}

@end
