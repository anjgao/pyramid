//
//  UserCentre.m
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "UserCentre.h"
#import "STKeychain.h"

NSString * loginUserName = @"linkkk";
NSString * loginNameService = @"linkkkname";
NSString * loginPasswordService = @"linkkkPW";


@implementation UserCentre

-(BOOL)storeUserName:(NSString*)name andPW:(NSString*)pw
{
    NSError* err = nil;
    BOOL success;
    success = [STKeychain storeUsername:loginUserName andPassword:name forServiceName:loginNameService updateExisting:YES error:&err];
    if (!success) {
        LKLog(err.localizedDescription);
        return NO;
    }
    
    success = [STKeychain storeUsername:name andPassword:pw forServiceName:loginPasswordService updateExisting:YES error:&err];
    if (!success) {
        LKLog(err.localizedDescription);
        return NO;
    }
    
    return YES;
}

-(BOOL)getUserName:(NSString**)pName andPW:(NSString**)pPW
{
    NSError* err = nil;
    NSString* name = [STKeychain getPasswordForUsername:loginUserName andServiceName:loginNameService error:&err];
    if (name == nil) {
        LKLog(err.localizedDescription);
        return NO;
    }
    *pName = name;
    
    NSString* pw = [STKeychain getPasswordForUsername:name andServiceName:loginPasswordService error:&err];
    if (pw == nil) {
        LKLog(err.localizedDescription);
        return NO;
    }
    *pPW = pw;
    
    return YES;
}

-(void)deleteNameAndPW
{
    NSError* err = nil;
    NSString* name = [STKeychain getPasswordForUsername:loginUserName andServiceName:loginNameService error:&err];
    if (name == nil) {
        LKLog(err.localizedDescription);
        return;
    }

    [STKeychain deleteItemForUsername:name andServiceName:loginPasswordService error:&err];
    [STKeychain deleteItemForUsername:loginUserName andServiceName:loginPasswordService error:&err];
}

@end
