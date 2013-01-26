//
//  LKViewController.h
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKViewController : UIViewController

@property(nonatomic,retain) MBProgressHUD * hud;

@property(nonatomic,assign)UINavigationController * navCtl;
-(void)pushCtl:(UIViewController*)ctl;

@end
