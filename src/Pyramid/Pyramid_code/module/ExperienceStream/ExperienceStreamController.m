//
//  ExperienceStreamController.m
//  Pyramid
//
//  Created by andregao on 13-1-24.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ExperienceStreamController.h"
#import "JsonObj.h"
#import "ExperienceController.h"

#define CELL_IMG 600

@interface ExperienceStreamController ()
{
    NSNumber * _userID;
}
@end

@implementation ExperienceStreamController

- (id)initWithUserID:(NSNumber*)userID
{
    self = [super initWithCapacity:20];
    _userID = userID;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_table cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    Json_experience * exp = (Json_experience*)_data[indexPath.row];
    ExperienceController * expCtl = [[ExperienceController alloc] initWithExp:exp];
    expCtl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:expCtl animated:YES];
}

#pragma mark - LKTableControllerDelegate
-(void)createCellSubviews:(UITableViewCell*)cell
{
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 320, 180)];
    imgV.tag = CELL_IMG;
    [cell.contentView addSubview:imgV];
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data index:(NSIndexPath *)index forHeight:(BOOL)bForHeight
{
    Json_experience * exp = (Json_experience*)data;
    
    UIImageView * imgV = (UIImageView*)[cell.contentView viewWithTag:CELL_IMG];
    imgV.image = nil;
    NSDictionary * imgDic = @{@"index":index};
    if ([LK_CONFIG isRetina])
        [self requestCellItem:exp.activity_profile.cover_image.medium userInfo:imgDic];
    else
        [self requestCellItem:exp.activity_profile.cover_image.small userInfo:imgDic];
}

-(NSString*)requestUrlPath:(BOOL)bRefresh
{
    NSNumber * start = @2147483647;     // todo news id超过该数值时
    if (_data.count > 0 && !bRefresh) {
        Json_experience* last = (Json_experience*)[_data lastObject];
        start = last.id;
    }
    NSString* urlPath = [NSString stringWithFormat:@"/api/alpha/participated/?id__lt=%@&limit=20&&order_by=-id&user=%@",start.stringValue,_userID.stringValue];
    
    return urlPath;
}

-(void)loadSuccess:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    json2obj(request.responseData, ExperienceStreamResponse)
    [_data addObjectsFromArray:repObj.objects];
    if (repObj.objects.count < 20) {
        _bLoadFinish = YES;
    }
}

-(void)loadFailed:(ASIHTTPRequest *)request bRefresh:(BOOL)bRefresh
{
    
}

-(void)cellItemLoadFinish:(ASIHTTPRequest*)request
{
    NSIndexPath * index = [request.userInfo objectForKey:@"index"];
    UITableViewCell* cell = [_table cellForRowAtIndexPath:index];
    if (cell) {
        UIImageView * img = (UIImageView*)[cell.contentView viewWithTag:CELL_IMG];
        img.image = [UIImage imageWithData:request.responseData];
    }
}

-(void)cellItemLoadFailed:(ASIHTTPRequest*)request
{
    
}


@end
