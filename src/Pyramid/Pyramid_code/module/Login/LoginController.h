//
//  LoginController.h
//  Pyramid
//
//  Created by andregao on 13-1-11.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginCtlDelegate <NSObject>
-(void)loginSuccess;
@end

@interface LoginController : LKViewController
@property(nonatomic,assign)   id<LoginCtlDelegate> delegate;
@end
