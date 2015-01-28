//
//  NSFileManager+USNDocuments.h
//  Common
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (UFCDocuments)

+ (NSString *) ufc_documentsDirectoryPath;
+ (NSURL *) ufc_documentsDirectoryURL;

+ (BOOL) ufc_saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path;
+ (BOOL) ufc_saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path allowBackUp:(BOOL)allowBackUp;

+ (BOOL) ufc_deleteDataFromDocumentDirectoryWithPath:(NSString *)path;

+ (NSData *) ufc_retrieveDataFromDocumentDirectoryWithPath:(NSString *)path;

+ (BOOL) ufc_copyMainBundleDirectory:(NSString *)mainBundleDirectory toDocumentsDirectoryPath:(NSString *)path;
+ (BOOL) ufc_copyMainBundleDirectory:(NSString *)mainBundleDirectory toDocumentsDirectoryPath:(NSString *)path allowBackUp:(BOOL)allowBackUp;

+ (BOOL) ufc_fileExistsInDocumentDirectory:(NSString *)path;

+ (BOOL) ufc_addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
