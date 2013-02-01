//
//  ConfigCentre.h
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigCentre : NSObject
@property(nonatomic,readonly,retain) UIImage * linkeeBg;
-(void)clearSessionCookie;
-(void)clearCache;
-(BOOL)isRetina;
-(BOOL)isiPhone5;
-(NSString*)dateDisplayString:(NSString*)date;
-(NSString*)tagFrom;
@end
