//
//  NSFileManager+USNDocuments.m
//  Common
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "NSFileManager+UFCDocuments.h"
#include <sys/xattr.h>
#import "NSString+UFCEmpty.h"

@implementation NSFileManager (UFCDocuments)


#pragma mark - Documents

+ (NSString *) ufc_documentsDirectoryPath
{
    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    return [documentsDirectoryURL path];
}

+ (NSURL *) ufc_documentsDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Saving

+ (BOOL) ufc_saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path
{
    return [NSFileManager ufc_saveData:data
              toDocumentsDirectoryPath:path
                           allowBackUp:NO];
}

+ (BOOL) ufc_saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path allowBackUp:(BOOL)allowBackUp
{
    BOOL success = NO;
    
    if ([data length] > 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *documentDirectory	= [NSFileManager ufc_documentsDirectoryPath];
        NSString *directoryPath = [path stringByDeletingLastPathComponent];
        
        BOOL createdDirectory = YES;
        
        if (![NSString ufc_isEmpty:directoryPath])
        {
            NSString *extendedDirectoryPath = [documentDirectory stringByAppendingPathComponent:directoryPath];
            
            if (![fileManager fileExistsAtPath:extendedDirectoryPath])
            {
                NSError* error = nil;
                
                createdDirectory = [fileManager createDirectoryAtPath:extendedDirectoryPath
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
            NSString *extendedPath = [documentDirectory stringByAppendingPathComponent:path];
            
            NSError *error = nil;
            
            success = [data writeToFile:extendedPath
                                options:NSDataWritingAtomic
                                  error:&error];
            
            if (error)
            {
                NSLog(@"Error when attempting to write data to documents directory: %@", [error userInfo]);
            }
            else
            {
                if (!allowBackUp)
                {
                    [NSFileManager ufc_addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:extendedPath]];
                }
            }
        }
    }
    
    return success;
    
}

#pragma mark - Retrieval

+ (NSData *) ufc_retrieveDataFromDocumentDirectoryWithPath:(NSString *)path
{
    NSString *documentDirectory	= [NSFileManager ufc_documentsDirectoryPath];
    NSString *extendedPath = [documentDirectory stringByAppendingPathComponent:path];
    
    return [NSData dataWithContentsOfFile:extendedPath];
}

#pragma mark - Deleting

+ (BOOL) ufc_deleteDataFromDocumentDirectoryWithPath:(NSString *)path
{
    NSString *documentDirectory	= [NSFileManager ufc_documentsDirectoryPath];
    NSString *extendedPath = [documentDirectory stringByAppendingPathComponent:path];
    
    NSError *error = nil;
    
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:extendedPath
                                                              error:&error];
    
    if (error)
    {
        NSLog(@"Error when attempting to delete media from disk: %@", [error userInfo]);
    }
    
    return success;
    
}

#pragma mark - Copying

+ (BOOL) ufc_copyMainBundleDirectory:(NSString *)mainBundleDirectory toDocumentsDirectoryPath:(NSString *)path allowBackUp:(BOOL)allowBackUp
{
    BOOL success = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentDirectory	= [NSFileManager ufc_documentsDirectoryPath];
    
    NSString *extendedPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, path];
    
    BOOL createdDirectory = YES;
    
    if (![NSString ufc_isEmpty:path])
    {
        if (![fileManager fileExistsAtPath:extendedPath])
        {
            NSError* error = nil;
            
            createdDirectory = [fileManager createDirectoryAtPath:extendedPath
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
        
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mainBundleDirectory];
        NSArray *directoryContent = [fileManager contentsOfDirectoryAtPath:bundlePath
                                                                     error:nil];
        
        for (NSString *filename in directoryContent)
        {
            NSString *destinationPath = [extendedPath stringByAppendingPathComponent:filename];
            
            if (![fileManager fileExistsAtPath:destinationPath])
            {
                NSString *sourcePath = [bundlePath stringByAppendingPathComponent:filename];
                
                NSError *error = nil;
                
                [fileManager copyItemAtPath:sourcePath
                                     toPath:destinationPath
                                      error:nil];
                
                if (error)
                {
                    NSLog(@"Error when copy file from main bundle to documents directory: %@", [error userInfo]);
                }
                else
                {
                    
                    if (!allowBackUp)
                    {
                        [NSFileManager ufc_addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:destinationPath]];
                    }
                    
                }
                
                
            }
        }
        
    }
    
    return success;
    
}

+ (BOOL) ufc_copyMainBundleDirectory:(NSString *)mainBundleDirectory toDocumentsDirectoryPath:(NSString *)path
{
    return [NSFileManager ufc_copyMainBundleDirectory:mainBundleDirectory
                             toDocumentsDirectoryPath:path
                                          allowBackUp:NO];
}

#pragma mark - Back up

+ (BOOL) ufc_addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    BOOL success = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[URL path]])
    {
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        
        success = (result == 0);
    }
    else
    {
        NSLog(@"File does not exist: %@", URL);
    }
    
    return success;
}

#pragma mark - File exists

+ (BOOL) ufc_fileExistsInDocumentDirectory:(NSString *)path
{
    NSString *documentDirectory	= [NSFileManager ufc_documentsDirectoryPath];
    
    NSString *extendedPath = [documentDirectory stringByAppendingPathComponent:path];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:extendedPath];
}


@end
