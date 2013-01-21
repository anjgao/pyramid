//
//  LinkeeStreamController.m
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeStreamController.h"
#import "JsonObj.h"

#define CELL_TEXT           250
#define CELL_IMG            251
#define CELL_CONTENT_IMG    252

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
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data index:(NSIndexPath *)index forHeight:(BOOL)bForHeight
{
    Json_linkee* objData = [self getCellLinkee:data];
    if (objData == nil)
        return;
    
    if (!bForHeight) {
        UIImageView * img = (UIImageView*)[cell viewWithTag:CELL_IMG];
        img.image = nil;
        UIImageView * contentImg = (UIImageView*)[cell viewWithTag:CELL_CONTENT_IMG];
        [contentImg removeFromSuperview];
        
        NSDictionary * imgDic = @{@"index":index,@"type":@0};
        if ([LK_CONFIG isRetina])
            [self requestCellItem:objData.author.medium_avatar userInfo:imgDic];
        else
            [self requestCellItem:objData.author.small_avatar userInfo:imgDic];
        
        if (objData.image) {
            NSDictionary * imgDic = @{@"index":index,@"type":@1};
            if ([LK_CONFIG isRetina])
                [self requestCellItem:objData.image.medium userInfo:imgDic];
            else
                [self requestCellItem:objData.image.small userInfo:imgDic];
        }
    }
    
    UILabel* text = (UILabel*)[cell viewWithTag:CELL_TEXT];
    CGRect frame = text.frame;
    frame.size = CGSizeMake(cell.bounds.size.width - 20, 0);
    text.frame = frame;
    text.text = objData.content;
    [text sizeToFit];
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = text.frame.size.height + 80;
    if (objData.image) {
        int h = [self heightWithWidth:[objData.image.raw_width intValue] height:[objData.image.raw_height intValue]];
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
            UIImageView * img = [[UIImageView alloc] initWithImage:contentImg];
            img.tag = CELL_CONTENT_IMG;
            CGRect imgFrame = img.frame;
            if ([LK_CONFIG isRetina]) {
                imgFrame.size.height /= 2;
                imgFrame.size.width /= 2;
            }
            imgFrame.origin = CGPointMake((cell.frame.size.width - imgFrame.size.width)/2, cell.frame.size.height - 10 - imgFrame.size.height);
            img.frame = imgFrame;
            [cell.contentView addSubview:img];
        }
    }
}

-(void)cellItemLoadFailed:(ASIHTTPRequest*)request
{
    
}

#pragma mark - LinkeeStreamCtlDelegate
-(Json_linkee*)getCellLinkee:(id)data
{
    return nil;
}

#pragma mark - inner method
-(int)heightWithWidth:(int)width height:(int)height
{
    int imgSize = 80;
    if (LK_CONFIG.isRetina) {
        imgSize = 200;
    }
    
    if (width >= height) {
        imgSize = imgSize * height / width;
    }
    
    if (LK_CONFIG.isRetina) {
        return imgSize/2;
    }
    return imgSize;
}

@end
