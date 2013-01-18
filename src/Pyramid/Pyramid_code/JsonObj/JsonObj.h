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
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSNumber * weight;
@end

@interface Json_District : Jastor
@property(nonatomic,retain) Json_City * city;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSNumber * weight;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_meta : Jastor
@property(nonatomic,retain) NSNumber * limit;
@property(nonatomic,retain) NSNumber * offset;
@property(nonatomic,retain) NSNumber * total_count;
// @property(nonatomic,retain) NSString * next;
// @property(nonatomic,retain) NSString * previous;
@end

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
@property(nonatomic,retain) NSString * resource_uri;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_author : Jastor     // linkee作者、reply作者
@property(nonatomic,retain) Json_District * district;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * medium_avatar;
@property(nonatomic,retain) NSString * small_avatar;
@property(nonatomic,retain) NSString * story;
@property(nonatomic,retain) NSString * username;
@end

///////////////////////////////////////////////////////////////////////////////////////
@interface Json_mention : Jastor
@property(nonatomic,retain) NSNumber * end;
@property(nonatomic,retain) NSNumber * start;
@property(nonatomic,retain) NSNumber * user_id;
@end
