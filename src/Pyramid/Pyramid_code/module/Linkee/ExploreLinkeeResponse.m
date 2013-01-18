//
//  ExploreLinkeeResponse.m
//  Pyramid
//
//  Created by andregao on 13-1-16.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "ExploreLinkeeResponse.h"

@implementation Json_current_profile

@end

@implementation Json_activity

@end

@implementation Json_user

@end

@implementation Json_recent_replie
+ (Class)mentions_class {
    return [Json_mention class];
}
@end

@implementation Json_object
+ (Class)mentions_class {
    return [Json_mention class];
}

+ (Class)recent_replies_class {
    return [Json_recent_replie class];
}
@end

@implementation ExploreLinkeeResponse
+ (Class)objects_class {
    return [Json_object class];
}
@end
