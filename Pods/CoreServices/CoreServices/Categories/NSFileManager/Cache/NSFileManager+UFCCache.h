//
//  NSFileManager+USNCache.h
//  Common
//
//  Created by William Boles on 28/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (UFCCache)

+ (NSString *) ufc_cacheDirectoryPath;
+ (NSURL *) ufc_cacheDirectoryURL;

+ (NSString *) ufc_cacheDirectoryPathForResourceWithPath:(NSString *)path;
+ (NSURL *) ufc_cacheDirectoryURLForResourceWithPath:(NSString *)path;

+ (BOOL) ufc_saveData:(NSData *)data toCacheDirectoryPath:(NSString *)path;
+ (NSData *) ufc_retrieveDataFromCacheDirectoryWithPath:(NSString *)path;

+ (BOOL) ufc_fileExistsInCacheDirectory:(NSString *)path;

@end
