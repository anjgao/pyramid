//
//  JsonObj.m
//  Pyramid
//
//  Created by andregao on 13-1-16.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "JsonObj.h"

@implementation Json_City

@end

@implementation Json_District

@end

//@implementation Json_meta
//
//@end

@implementation Json_image

@end

@implementation Json_user

@end

@implementation Json_mention

@end

@implementation Json_mini_profile

@end

@implementation Json_mini_activity

@end

@implementation Json_mini_user

@end

@implementation Json_recent_replie
+ (Class)mentions_class {
    return [Json_mention class];
}
@end

@implementation Json_linkee
+ (Class)mentions_class {
    return [Json_mention class];
}

+ (Class)recent_replies_class {
    return [Json_recent_replie class];
}
@end

@implementation Json_news

@end

@implementation Json_people

@end

@implementation Json_reply
+ (Class)mentions_class {
    return [Json_mention class];
}
@end

@implementation Json_profile

@end

@implementation Json_activity

@end

@implementation Json_watchedExp

@end

@implementation Json_experience

@end

@implementation Json_pic_upload

@end

///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
@implementation ExploreLinkeeResponse
+ (Class)objects_class {
    return [Json_linkee class];
}
@end

@implementation NewsResponse
+ (Class)objects_class {
    return [Json_news class];
}
@end

@implementation PeopleStreamResponse
+ (Class)objects_class {
    return [Json_people class];
}
@end

@implementation ReplyStreamResponse : Jastor
+ (Class)objects_class {
    return [Json_reply class];
}
@end

@implementation ExperienceStreamResponse : Jastor
+ (Class)objects_class {
    return [Json_experience class];
}
@end

@implementation HostedExpStreamResponse : Jastor
+ (Class)objects_class {
    return [Json_activity class];
}
@end

@implementation WatchedExpStreamResponse : Jastor
+ (Class)objects_class {
    return [Json_watchedExp class];
}
@end

@implementation PicUploadResponse : Jastor

@end

@implementation DeleteLinkeeResponse : Jastor

@end

@implementation NewLinkeeResponse : Jastor
+ (Class)mentions_class {
    return [Json_mention class];
}
@end

@implementation ReplyResponse : Jastor
+ (Class)mentions_class {
    return [Json_mention class];
}
@end

@implementation RelinkeeResponse : Jastor

@end

