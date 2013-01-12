//
//  handyTool.h
//  Pyramid
//
//  Created by andregao on 13-1-12.
//  Copyright (c) 2013年 linkkk.com. All rights reserved.
//

#ifndef Pyramid_handyTool_h
#define Pyramid_handyTool_h

// 
#define LKString(key)      NSLocalizedString(@#key,nil)

//
NSURL* linkkkUrl(NSString* urlPath);

// repObj
#define json2obj(jsonData,ObjClass)                                                                         \
    ObjClass* repObj = nil;                                                                                 \
    {                                                                                                       \
        NSError* err;                                                                                       \
        NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];     \
        if (err) {                                                                                          \
            LKLog([err localizedDescription]);                                                              \
        }                                                                                                   \
        else {                                                                                              \
            @try {                                                                                          \
                repObj = [[LoginResponse alloc] initWithDictionary:dataDic];                                \
            }                                                                                               \
            @catch (NSException *exception) {                                                               \
                LKLog(@"!!!!! json: dictionary to object error !!!!!");                                     \
            }                                                                                               \
        }                                                                                                   \
    }

//


#endif
