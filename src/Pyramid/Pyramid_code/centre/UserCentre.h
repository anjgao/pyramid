//
//  UserCentre.h
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonProfile;

@interface UserCentre : NSObject

@property(nonatomic,retain) NSNumber *   userID;
@property(nonatomic,retain) NSString *   xsrfToken;
@property(nonatomic,retain) PersonProfile * profile;

// userName and password
-(BOOL)storeUserName:(NSString*)name andPW:(NSString*)pw;
-(BOOL)getUserName:(NSString**)pName andPW:(NSString**)pPW;
-(void)deleteNameAndPW;

@end
