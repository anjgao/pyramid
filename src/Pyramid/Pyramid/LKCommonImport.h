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

#define LK_APP      ((LKAppDelegate*)[UIApplication sharedApplication].delegate)
#define LK_UI       LK_APP.objUICentre

// tool
#import "LKDebugTool.h"

// common header
#import <QuartzCore/QuartzCore.h>
#import "LKViewController.h"

// useful Macros
#define LKString(key)      NSLocalizedString(key,nil)

#endif
