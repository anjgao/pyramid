//
//  LinkeeStreamController.m
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeStreamController.h"
#import "JsonObj.h"
#import "LinkeeDetailController.h"

#define CELL_TEXT           250
#define CELL_IMG            251
#define CELL_CONTENT_IMG    252
#define CELL_NAME           253
#define CELL_TIME           254

@interface LinkeeStreamController ()

@end

@implementation LinkeeStreamController

#pragma mark - LKTableControllerDelegate
-(void)createCellSubviews:(UITableViewCell*)cell
{
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, cell.bounds.size.width-20, 0)];
    text.tag = CELL_TEXT;
    text.numberOfLines = 0;
    text.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:text];
    
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.tag = CELL_IMG;
    [cell.contentView addSubview:img];
    
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, cell.bounds.size.width-80, 20)];
    name.tag = CELL_NAME;
    [cell.contentView addSubview:name];
    
    UILabel* time = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, cell.bounds.size.width-80, 20)];
    time.tag = CELL_TIME;
    time.font = [UIFont systemFontOfSize:13];
    time.textColor = [UIColor grayColor];
    [cell.contentView addSubview:time];
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data index:(NSIndexPath *)index forHeight:(BOOL)bForHeight
{
    Json_linkee* objData = [self getCellLinkee:data];
    if (objData == nil)
        return;
    
    if (!bForHeight) {
        // name
        UILabel * name = (UILabel*)[cell viewWithTag:CELL_NAME];
        name.text = objData.author.username;
        
        // time
        UILabel * time = (UILabel*)[cell viewWithTag:CELL_TIME];
        time.text = [LK_CONFIG dateDisplayString:objData.created];
        
        // avatar
        UIImageView * img = (UIImageView*)[cell viewWithTag:CELL_IMG];
        img.image = nil;
        NSDictionary * imgDic = @{@"index":index,@"type":@0};
        if ([LK_CONFIG isRetina])
            [self requestCellItem:objData.author.medium_avatar userInfo:imgDic];
        else
            [self requestCellItem:objData.author.small_avatar userInfo:imgDic];
        
        // content image
        UIImageView * contentImg = (UIImageView*)[cell viewWithTag:CELL_CONTENT_IMG];
        [contentImg removeFromSuperview];
        if (objData.image) {
            NSDictionary * imgDic = @{@"index":index,@"type":@1};
            if ([LK_CONFIG isRetina])
                [self requestCellItem:objData.image.medium userInfo:imgDic];
            else
                [self requestCellItem:objData.image.small userInfo:imgDic];
        }
    }
    
    // content
    UILabel* text = (UILabel*)[cell viewWithTag:CELL_TEXT];
    CGRect frame = text.frame;
    frame.size = CGSizeMake(cell.bounds.size.width - 20, 0);
    text.frame = frame;
    text.text = objData.content;
    [text sizeToFit];
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = text.frame.size.height + 80;
    if (objData.image) {
        int h = [self sizeWithWidth:[objData.image.raw_width intValue] height:[objData.image.raw_height intValue]].height;
        cellFrame.size.height += (h+10);
    }
    cell.frame = cellFrame;
}

-(void)cellItemLoadFinish:(ASIHTTPRequest*)request
{
    NSIndexPath * index = [request.userInfo objectForKey:@"index"];
    int type = [((NSNumber*)[request.userInfo objectForKey:@"type"]) intValue];
    
    UITableViewCell* cell = [_table cellForRowAtIndexPath:index];
    if (cell) {
        if (type == 0) {
            UIImageView * img = (UIImageView*)[cell viewWithTag:CELL_IMG];
            img.image = [UIImage imageWithData:request.responseData];
        }
        else if (type == 1) {
            UIImage * contentImg = [UIImage imageWithData:request.responseData];
//            UIImage * scale = [UIImage imageWithCGImage:contentImg.CGImage scale:2.0 orientation:UIImageOrientationUp];
            UIImageView * img = [[UIImageView alloc] initWithImage:contentImg];
            img.contentMode = UIViewContentModeScaleAspectFit;
            img.tag = CELL_CONTENT_IMG;
            CGRect imgFrame = img.frame;
            if ([LK_CONFIG isRetina]) {
                if (contentImg.size.height > 201) {
                    imgFrame.size = [self sizeWithWidth:contentImg.size.width height:contentImg.size.height];
                }
                else {
                    imgFrame.size.height /= 2;
                    imgFrame.size.width /= 2;
                }
            }
            else {
                if (contentImg.size.height > 81) {
                    imgFrame.size = [self sizeWithWidth:contentImg.size.width height:contentImg.size.height];                    
                }
            }
            imgFrame.origin = CGPointMake((cell.frame.size.width - imgFrame.size.width)/2, cell.frame.size.height - 10 - imgFrame.size.height);
            img.frame = imgFrame;
            [cell.contentView addSubview:img];
        }
    }
}

-(void)cellItemLoadFailed:(ASIHTTPRequest*)request
{
    // todo 显示拉取失败的图
}

#pragma mark - LinkeeStreamCtlDelegate
-(Json_linkee*)getCellLinkee:(id)data
{
    return nil;
}

#pragma mark - inner method
-(CGSize)sizeWithWidth:(int)width height:(int)height
{
    CGSize retSize = CGSizeZero;
    int imgSize = 80;
    if (LK_CONFIG.isRetina) {
        imgSize = 200;
    }
    
    if (width >= height) {
        retSize.height = imgSize * height / width;
        retSize.width = imgSize;
    }
    else {
        retSize.width = imgSize * width / height;
        retSize.height = imgSize;
    }
    
    if (LK_CONFIG.isRetina) {
        retSize.height /= 2;
        retSize.width /= 2;
    }
    return retSize;
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_table cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    Json_linkee * item = [self getCellLinkee: _data[indexPath.row]];
    LinkeeDetailController * ldCtl = [[LinkeeDetailController alloc] initWithLinkee:item];
    
    if (self.navigationController)
        [self.navigationController pushViewController:ldCtl animated:YES];
    else
        [_navCtl pushViewController:ldCtl animated:YES];
}


@end
