//
//  LKNavigationController.m
//  Pyramid
//
//  Created by andregao on 13-1-10.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "LKNavigationController.h"

@interface LKNavigationController ()

@end

@implementation LKNavigationController

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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
        viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == navigationController.viewControllers[0])
        [navigationController setNavigationBarHidden:YES animated:YES];
    else
        [navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
