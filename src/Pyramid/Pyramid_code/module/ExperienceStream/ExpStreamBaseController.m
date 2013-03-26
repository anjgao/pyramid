//
//  ExpStreamBaseController.m
//  Pyramid
//
//  Created by andregao on 13-1-30.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ExpStreamBaseController.h"
#import "JsonObj.h"
#import "ExperienceController.h"

#define CELL_IMG 600

@interface ExpStreamBaseController ()

@end

@implementation ExpStreamBaseController

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
    
    NSNumber * expID = [self getID:_data[indexPath.row]];
    if (expID) {
        ExperienceController * expCtl = [[ExperienceController alloc] initWithExp:expID];
        [self.navigationController pushViewController:expCtl animated:YES];
    }
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
    Json_profile * expProfile = [self getExpProfile:data];
    
    UIImageView * imgV = (UIImageView*)[cell.contentView viewWithTag:CELL_IMG];
    imgV.image = nil;
    NSDictionary * imgDic = @{@"index":index};
    if ([LK_CONFIG isRetina])
        [self requestCellItem:expProfile.cover_image.medium userInfo:imgDic];
    else
        [self requestCellItem:expProfile.cover_image.small userInfo:imgDic];
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

#pragma mark - ExpStreamCtlDelegate
- (NSNumber*)getID:(id)item
{
    return nil;
}

- (Json_profile*)getExpProfile:(id)item
{
    return nil;
}

@end
