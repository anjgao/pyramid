//
//  SettingController.m
//  Pyramid
//
//  Created by andregao on 13-1-14.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "SettingController.h"
#import "ASIHTTPRequest.h"

@interface SettingController ()

@end

@implementation SettingController

-(id)init
{
    self = [super init];
    self.title = LKString(setting);
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UIButton* clearCache = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clearCache.frame = CGRectMake(10, 10, 300, 30);
    [clearCache setTitle:LKString(clearCache) forState:UIControlStateNormal];
    [clearCache addTarget:self action:@selector(cleanCacheBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearCache];
    
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutBtn.frame = CGRectMake(10, 50, 300, 30);
    [logoutBtn setTitle:LKString(logout) forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    
    UIButton* cc = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cc.frame = CGRectMake(10, 90, 300, 30);
    [cc setTitle:@"print cookies" forState:UIControlStateNormal];
    [cc addTarget:self action:@selector(ccBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cc];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ccBtnPressed:(UIButton*)ccBtn
{
    printCookies();
}


//
-(void)logoutBtnPressed:(UIButton*)logoutBtn
{
    [LK_TASK logout:nil];
}

-(void)cleanCacheBtnPressed:(UIButton*)ccBtn
{
    [LK_CONFIG clearCache];
}

@end
