//
//  PeopleStreamController.m
//  Pyramid
//
//  Created by andregao on 13-1-22.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "PeopleStreamController.h"
#import "JsonObj.h"
#import "PersonalController.h"

#define CELL_NAME    300
#define CELL_HEAD    301


@interface PeopleStreamController ()
{
    NSNumber * _userID;
}
@end

@implementation PeopleStreamController

- (id)initWithID:(NSNumber*)userID
{
    self = [super initWithCapacity:20];
    
    _userID = userID;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_table cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    NSNumber * userID = ((Json_people*)_data[indexPath.row]).follow.id;
    PersonalController * peopleCtl = [[PersonalController alloc] init];
    [self.navigationController pushViewController:peopleCtl animated:YES];
    [peopleCtl showProfileWithID:userID];
}

#pragma mark - LKTableControllerDelegate
-(void)createCellSubviews:(UITableViewCell*)cell
{
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 300, 20)];
    name.tag = CELL_NAME;
    [cell.contentView addSubview:name];
    
    UIImageView * head = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    head.tag = CELL_HEAD;
    [cell.contentView addSubview:head];
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data index:(NSIndexPath *)index forHeight:(BOOL)bForHeight
{
    Json_people* item = (Json_people*)data;
    if (bForHeight)
        return;
    
    UILabel * name = (UILabel*)[cell.contentView viewWithTag:CELL_NAME];
    name.text = item.follow.username;
    
    NSDictionary * imgDic = @{@"index":index};
    UIImageView * head = (UIImageView*)[cell.contentView viewWithTag:CELL_HEAD];
    head.image = nil;
    if ([LK_CONFIG isRetina])
        [self requestCellItem:item.follow.medium_avatar userInfo:imgDic];
    else
        [self requestCellItem:item.follow.small_avatar userInfo:imgDic];
}

-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    NSNumber * start = @2147483647;     // todo news id超过该数值时
    if (_data.count > 0 && !bRefresh) {
        Json_people* last = (Json_people*)[_data lastObject];
        start = last.id;
    }
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/network/?id__lt=%@&limit=20&order_by=-id&user=%@",start.stringValue,[_userID stringValue]];
    
    return urlPath;
}

-(void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    json2obj(request.responseData, PeopleStreamResponse)
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
}

-(void)cellItemLoadFinish:(ASIHTTPRequest*)request
{
    NSIndexPath * index = [request.userInfo objectForKey:@"index"];
    UITableViewCell* cell = [_table cellForRowAtIndexPath:index];
    if (cell) {
        UIImageView * img = (UIImageView*)[cell.contentView viewWithTag:CELL_HEAD];
        img.image = [UIImage imageWithData:request.responseData];
    }
}


@end
