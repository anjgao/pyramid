//
//  LoginController.m
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

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
	// Do any additional setup after loading the view.
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)];
    label.text = @"login";
    [self.view addSubview:label];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 60, 300, 30);
//    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 60, 300, 30)];
    [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"login" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)btnSelected:(id)btn
{
    [_delegate loginSuccess];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
