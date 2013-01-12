//
//  ConfigCentre.m
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ConfigCentre.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIHTTPRequestConfig.h"

@implementation ConfigCentre

-(id)init
{
    self = [super init];
    
    // ASIHTTPRequest
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
    return self;
}


@end
