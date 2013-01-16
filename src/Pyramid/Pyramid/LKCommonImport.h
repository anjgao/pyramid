//
//  LKCommonImport.h
//  Pyramid
//
//  Created by andregao on 13-1-10.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#ifndef Pyramid_LKCommonImport_h
#define Pyramid_LKCommonImport_h

// appDelete & centres
#import "LKAppDelegate.h"
#import "UICentre.h"
#import "ConfigCentre.h"
#import "UserCentre.h"
#import "TaskCentre.h"

#define LK_APP      ((LKAppDelegate*)[UIApplication sharedApplication].delegate)
#define LK_UI       LK_APP.objUICentre
#define LK_CONFIG   LK_APP.objConfigCentre
#define LK_USER     LK_APP.objUserCentre
#define LK_TASK     LK_APP.objTaskCentre

// tool
#import "LKDebugTool.h"
#import "handyTool.h"

// common header
#import <QuartzCore/QuartzCore.h>
#import "LKViewController.h"

#endif
