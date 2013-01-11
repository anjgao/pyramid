//
//  LKTabBarController.m
//  Pyramid
//
//  Created by andregao on 13-1-10.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKTabBarController.h"

@interface LKTabBarController ()

@end

@implementation LKTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//    [self createCustomViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - inner method
- (void)createCustomBtns
{
//    UIView* bg = [[UIView alloc] initWithFrame:self.tabBar.bounds];
//    bg.backgroundColor = [UIColor blueColor];
//    [self.tabBar addSubview:bg];
    
    for (int i=0; i<4; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(i*80, 9, 80, 15);
        btn.tag = 100+i;
        [self.tabBar addSubview:btn];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)btnPressed:(id)btn
{
    int index = ((UIView*)btn).tag - 100;
    self.selectedIndex = index;
}

@end
