//
//  LKViewController.m
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKViewController.h"

@interface LKViewController ()

@end

@implementation LKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HUD
-(MBProgressHUD*)hud
{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.detailsLabelFont = [UIFont systemFontOfSize:20];
        [self.view addSubview:_hud];
    }
    return _hud;
}

#pragma mark - navCtl
-(void)pushCtl:(UIViewController*)ctl
{
    if (self.navigationController)
        [self.navigationController pushViewController:ctl animated:YES];
    else
        [_navCtl pushViewController:ctl animated:YES];
}

#pragma mark
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
