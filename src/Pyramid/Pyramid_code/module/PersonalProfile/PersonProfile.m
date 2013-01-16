//
//  PersonProfile.m
//  Pyramid
//
//  Created by andregao on 13-1-15.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#import "PersonProfile.h"

@implementation Json_Avatar

@end

@implementation Json_City

@end

@implementation Json_District

@end

@implementation Json_Provider_Profile

@end

@implementation Json_Experience

@end

@implementation Json_Hosted_Experience

@end

@implementation Json_Role

@end

@implementation Json_Level

@end

@implementation Json_Stat
+ (Class)experiences_class {
    return [Json_Experience class];
}

+ (Class)hosted_experiences_class {
    return [Json_Hosted_Experience class];
}

+ (Class)levels_class {
    return [Json_Level class];
}
@end

@implementation PersonProfile

@end
