//
//  JsonObj.h
//  Pyramid
//
//  Created by andregao on 13-1-16.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "Jastor.h"

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_City : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * name;
//@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSNumber * weight;
@end

@interface Json_District : Jastor
@property(nonatomic,retain) Json_City * city;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * name;
//@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSNumber * weight;
@end

///////////////////////////////////////////////////////////////////////////////////////
//@interface Json_meta : Jastor
//@property(nonatomic,retain) NSNumber * limit;
//@property(nonatomic,retain) NSNumber * offset;
//@property(nonatomic,retain) NSNumber * total_count;
//@property(nonatomic,retain) NSString * next;
//@property(nonatomic,retain) NSString * previous;
//@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_image : Jastor      // 经历封面图、linkee中的图
@property(nonatomic,retain) NSString * caption;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * large;
@property(nonatomic,retain) NSString * medium;
@property(nonatomic,retain) NSString * small;
@property(nonatomic,retain) NSString * raw;
@property(nonatomic,retain) NSNumber * raw_width;
@property(nonatomic,retain) NSNumber * raw_height;
//@property(nonatomic,retain) NSString * resource_uri;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_user : Jastor     // linkee作者、reply作者、好友列表项
@property(nonatomic,retain) Json_District * district;
@property(nonatomic,retain) NSNumber * id;
//@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * medium_avatar;
@property(nonatomic,retain) NSString * small_avatar;
@property(nonatomic,retain) NSString * story;
@property(nonatomic,retain) NSString * username;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_mention : Jastor
@property(nonatomic,assign) int end;
@property(nonatomic,assign) int start;
@property(nonatomic,retain) NSNumber * user_id;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_current_profile : Jastor
@property(nonatomic,retain) Json_image * cover_image;
@property(nonatomic,retain) NSString * name;
//@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_activity : Jastor
@property(nonatomic,retain) Json_current_profile * current_profile;
@property(nonatomic,retain) NSNumber * id;
//@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_recent_replie : Jastor
@property(nonatomic,retain) Json_user * author;
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * created;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSNumber * linkee;
@property(nonatomic,retain) NSArray * mentions;
//@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_mini_user : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * username;
@property(nonatomic,retain) NSString * story;
//@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_linkee : Jastor
@property(nonatomic,retain) Json_activity * activity;
@property(nonatomic,retain) Json_user * author;
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
@property(nonatomic,retain) Json_mini_user * user;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_news : Jastor
@property(nonatomic,retain) Json_linkee * linkee;
@property(nonatomic,retain) NSNumber * id;
//@property(nonatomic,retain) NSString * resource_uri;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_people : Jastor
@property(nonatomic,retain) Json_user * follow;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * user;
//@property(nonatomic,retain) NSString * resource_uri;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_reply : Jastor
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * created;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSNumber * linkee;
@property(nonatomic,retain) NSArray * mentions;
@property(nonatomic,retain) Json_user * author;
//@property(nonatomic,retain) NSString * resource_uri;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_activity_profile : Jastor
@property(nonatomic,retain) NSString * abstract;
@property(nonatomic,retain) NSString * address;
@property(nonatomic,retain) Json_image * cover_image;
@property(nonatomic,retain) NSString * created;
@property(nonatomic,retain) Json_District * district;
@property(nonatomic,retain) NSNumber * market_price;
@property(nonatomic,retain) NSString * name;
//@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_experience : Jastor
@property(nonatomic,retain) Json_activity_profile * activity_profile;
@property(nonatomic,retain) NSNumber * id;
//@property(nonatomic,retain) Json_team * team;     // todo
@property(nonatomic,retain) NSString * user;
//@property(nonatomic,retain) NSString * resource_uri;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_pic_upload : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * raw;
// raw_dimension
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * thumbnail_uri;
@end

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
@interface ExploreLinkeeResponse : Jastor
//@property(nonatomic,retain) Json_meta * meta;
@property(nonatomic,retain) NSArray * objects;
@end

@interface NewsResponse : Jastor
//@property(nonatomic,retain) Json_meta * meta;
@property(nonatomic,retain) NSArray * objects;
@end

@interface PeopleStreamResponse : Jastor
//@property(nonatomic,retain) Json_meta * meta;
@property(nonatomic,retain) NSArray * objects;
@end

@interface ReplyStreamResponse : Jastor
//@property(nonatomic,retain) Json_meta * meta;
@property(nonatomic,retain) NSArray * objects;
@end

@interface ExperienceStreamResponse : Jastor
//@property(nonatomic,retain) Json_meta * meta;
@property(nonatomic,retain) NSArray * objects;
@end

@interface PicUploadResponse : Jastor
@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) Json_pic_upload* data;
@end

@interface DeleteLinkeeResponse : Jastor
@property(nonatomic,retain) NSString * status;
@end

@interface NewLinkeeResponse : Jastor
@property(nonatomic,retain) Json_activity * activity;
@property(nonatomic,retain) Json_user * author;
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * created;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) Json_image * image;
@property(nonatomic,assign) BOOL is_relinkee;
@property(nonatomic,retain) NSArray * mentions;
@property(nonatomic,retain) NSString * tag_from;
//@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) Json_mini_user * user;
@end

@interface ReplyResponse : Jastor
@property(nonatomic,retain) Json_user * author;
@property(nonatomic,retain) NSString * content;
@property(nonatomic,retain) NSString * created;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) Json_linkee * linkee;
@property(nonatomic,retain) NSArray * mentions;
//@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * tag_from;
@end

