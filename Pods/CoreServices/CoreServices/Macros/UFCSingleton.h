//
//  UFCSingleton.h
//  CoreServices
//
//  Created by James Campbell on 06/03/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#define SINGLETON_DECLARATION +(instancetype)sharedInstance

#define SINGLETON_IMPLIMENTATION(class) \
+(instancetype)sharedInstance \
{ \
    static dispatch_once_t pred; \
    static class * sharedInstance = nil; \
    dispatch_once(&pred, ^{ \
        sharedInstance = [[class alloc] init]; \
    }); \
    return sharedInstance; \
}
