//
//  LinkeeStreamController.m
//  Pyramid
//
//  Created by andregao on 13-1-19.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LinkeeStreamController.h"
#import "JsonObj.h"

#define LE_CELL_TEXT    250

@interface LinkeeStreamController ()

@end

@implementation LinkeeStreamController

#pragma mark - LKTableControllerDelegate
-(void)createCellSubviews:(UITableViewCell*)cell
{
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cell.bounds.size.width-20, 0)];
    text.tag = LE_CELL_TEXT;
    text.numberOfLines = 0;
    [cell.contentView addSubview:text];
}

-(void)fillCell:(UITableViewCell*)cell data:(id)data
{
    Json_linkee* objData = [self getCellLinkee:data];
    if (objData == nil)
        return;
    
    UILabel* text = (UILabel*)[cell viewWithTag:LE_CELL_TEXT];
    CGRect frame = text.frame;
    frame.size = CGSizeMake(cell.bounds.size.width - 20, 0);
    text.frame = frame;
    text.text = objData.content;
    [text sizeToFit];
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = text.frame.size.height + 20;
    cell.frame = cellFrame;
}

#pragma mark - LinkeeStreamCtlDelegate
-(Json_linkee*)getCellLinkee:(id)data
{
    return nil;
}

@end
