//
//  LoginResponse.h
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "Jastor.h"

@interface LoginResData : Jastor
@property(nonatomic,retain) NSNumber*           user_id;
@end

@interface LoginResInvalidations : Jastor
@property(nonatomic,retain) NSArray*            __all__;
@property(nonatomic,retain) NSArray*            login;
@property(nonatomic,retain) NSArray*            password;
@end

@interface LoginResponse : Jastor
@property(nonatomic,retain) NSString*           status;
@property(nonatomic,retain) LoginResData*       data;
@property(nonatomic,retain) NSArray*            message;
@property(nonatomic,retain) LoginResInvalidations*      invalidations;
@end
