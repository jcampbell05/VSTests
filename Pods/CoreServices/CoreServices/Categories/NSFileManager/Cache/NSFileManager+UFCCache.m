//
//  NSFileManager+USNCache.m
//  Common
//
//  Created by William Boles on 28/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "NSFileManager+UFCCache.h"
#import "NSString+UFCEmpty.h"

@implementation NSFileManager (UFCCache)

#pragma mark - Cache

+ (NSString *) ufc_cacheDirectoryPath
{
    return [[NSFileManager ufc_cacheDirectoryURL] path];
}

+ (NSURL *) ufc_cacheDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *) ufc_cacheDirectoryPathForResourceWithPath:(NSString *)path
{
    return [[NSFileManager ufc_cacheDirectoryURLForResourceWithPath:path] path];
}

+ (NSURL *) ufc_cacheDirectoryURLForResourceWithPath:(NSString *)path
{
    NSString *cacheDirectoryPathForResourceWithPath = [[NSFileManager ufc_cacheDirectoryPath] stringByAppendingPathComponent:path];
    
    return [NSURL fileURLWithPath:cacheDirectoryPathForResourceWithPath];
}

#pragma mark - Saving

+ (BOOL) ufc_saveData:(NSData *)data toCacheDirectoryPath:(NSString *)path
{
    BOOL success = NO;
    
    if ([data length] > 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *cacheDirectory = [NSFileManager ufc_cacheDirectoryPath];
        NSString *cachePath = [path stringByDeletingLastPathComponent];
        
        BOOL createdDirectory = YES;
        
        if (![NSString ufc_isEmpty:cachePath])
        {
            NSString *extendedCachePath = [cacheDirectory stringByAppendingPathComponent:cachePath];
            
            if (![fileManager fileExistsAtPath:extendedCachePath])
            {
                NSError* error = nil;
                
                createdDirectory = [fileManager createDirectoryAtPath:extendedCachePath
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&error];
                
                if(error)
                {
                    NSLog(@"Error when creating a directory at location: %@", path);
                }
            }
        }
        
        if (createdDirectory)
        {
            NSString *extendedPath = [cacheDirectory stringByAppendingPathComponent:path];
            
            NSError *error = nil;
            
            success = [data writeToFile:extendedPath
                                options:NSDataWritingAtomic
                                  error:&error];
            
            if (error)
            {
                NSLog(@"Error when attempting to write data to documents directory: %@", [error userInfo]);
            }
        }
    }
    
    return success;

}

#pragma mark - Retrieval

+ (NSData *) ufc_retrieveDataFromCacheDirectoryWithPath:(NSString *)path
{
    NSString *cacheDirectory = [NSFileManager ufc_cacheDirectoryPath];
    NSString *extendedPath = [cacheDirectory stringByAppendingPathComponent:path];
    
    return [NSData dataWithContentsOfFile:extendedPath];
}

#pragma mark - File exists

+ (BOOL) ufc_fileExistsInCacheDirectory:(NSString *)path
{
    NSString *cacheDirectory	= [NSFileManager ufc_cacheDirectoryPath];
    
    NSString *extendedPath = [cacheDirectory stringByAppendingPathComponent:path];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:extendedPath];
}

@end
