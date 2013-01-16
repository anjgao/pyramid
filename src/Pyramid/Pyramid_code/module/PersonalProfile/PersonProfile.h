//
//  PersonProfile.h
//  Pyramid
//
//  Created by andregao on 13-1-15.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "Jastor.h"

@interface Json_Avatar : Jastor
@property(nonatomic,retain) NSString * caption;
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * large;
@property(nonatomic,retain) NSString * medium;
@property(nonatomic,retain) NSString * raw;
@property(nonatomic,retain) NSNumber * raw_height;
@property(nonatomic,retain) NSNumber * raw_width;
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * small;
@end

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

@interface Json_Provider_Profile : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * address;
@property(nonatomic,retain) NSString * gender;
@property(nonatomic,retain) NSString * medium_avatar;
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * small_avatar;
@property(nonatomic,retain) NSNumber * user_id;
@property(nonatomic,retain) NSString * username;
@end

@interface Json_Experience : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * resource_uri;
@end

@interface Json_Hosted_Experience : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * small_cover;
@property(nonatomic,retain) NSString * verified;
@end

@interface Json_Role : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSNumber * group_weight;
@property(nonatomic,retain) NSString * icon;
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSNumber * weight;
@end

@interface Json_Level : Jastor
@property(nonatomic,retain) NSNumber * exp;
@property(nonatomic,retain) NSNumber * exp_for_current;
@property(nonatomic,retain) NSNumber * exp_for_next;
@property(nonatomic,retain) NSNumber * level;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) Json_Role * role;
@end

@interface Json_Stat : Jastor
@property(nonatomic,retain) NSNumber * team_count;
@property(nonatomic,retain) NSNumber * circle_count;
@property(nonatomic,retain) NSNumber * hosted_team_count;
@property(nonatomic,retain) NSNumber * watched_exp_count;
@property(nonatomic,retain) NSArray  * experiences;
@property(nonatomic,retain) NSArray  * hosted_experiences;
@property(nonatomic,retain) NSArray  * levels;
@end

@interface PersonProfile : Jastor
@property(nonatomic,retain) NSNumber * id;
@property(nonatomic,retain) NSString * gender;
@property(nonatomic,retain) NSString * resource_uri;
@property(nonatomic,retain) NSString * story;
@property(nonatomic,retain) NSString * username;
@property(nonatomic,retain) Json_Avatar * avatar;
@property(nonatomic,retain) Json_District * district;
@property(nonatomic,retain) Json_Provider_Profile * provider_profile;
@property(nonatomic,retain) Json_Stat * stat;
@end
