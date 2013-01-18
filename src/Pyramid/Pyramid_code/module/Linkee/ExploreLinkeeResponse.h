//
//  ExploreLinkeeResponse.h
//  Pyramid
//
//  Created by andregao on 13-1-16.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "Jastor.h"
#import "JsonObj.h"

@interface Json_current_profile : Jastor
@property(nonatomic,retain) Json_image * cover_image;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_activity : Jastor
@property(nonatomic,retain) Json_current_profile * current_profile;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_recent_replie : Jastor
@property(nonatomic,retain) Json_author * author;
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * created;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSNumber * linkee;
@property(nonatomic,retain) NSArray * mentions;
@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_user : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * username;
@property(nonatomic,retain) NSString * story;
@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_object : Jastor
@property(nonatomic,retain) Json_activity * activity;
@property(nonatomic,retain) Json_author * author;
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * created;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) Json_image * image;
@property(nonatomic,assign) BOOL is_deleted;
@property(nonatomic,assign) BOOL is_relinkee;
@property(nonatomic,retain) NSString * last_modified;
@property(nonatomic,retain) NSArray * mentions;
@property(nonatomic,retain) NSArray * recent_replies;
@property(nonatomic,retain) NSNumber * reply_count;
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) Json_user * user;
@end

@interface ExploreLinkeeResponse : Jastor
//@property(nonatomic,retain) Json_meta * meta;
@property(nonatomic,retain) NSArray * objects;
@end
