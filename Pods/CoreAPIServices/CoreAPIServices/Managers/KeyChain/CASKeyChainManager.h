//
//  CASKeyChainManager.h
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Responsible for providing access to the keychain
 */
@interface CASKeyChainManager : NSObject

/**
 Searches iOS keychain for an entry with supplied identifer and returns data if found
 @param identifier supplied identifier
 @return NSData object of found entry (nil if not found)
 */
+ (NSData *)retrieveDataForIdentifier:(NSString *)identifier;

/**
 Creates iOS keychain entry with data and identifier
 @param dataObject data to be stored in iOS keychain
 @param identifier supplied identifer used as a key to retrieve and save data to iOS keychain
 @return Success indicator
 */
+ (BOOL)setData:(NSData *)data forIdentifier:(NSString *)identifier;

/**
 Updates iOS keychain entry with data and identifier
 @param dataObject data to be stored in iOS keychain
 @param identifier supplied identifer used as a key to retrieve and save data to iOS keychain
 @return Success indicator
 */
+ (BOOL)updateData:(NSData *)data identifier:(NSString *)identifier;

/**
 Deletes iOS keychain entry
 @param identifier supplied identifier used to search iOS keychain
 */
+ (void)deleteDataForIdentifier:(NSString *)identifier;

/**
 Searches iOS keychain for an entry with supplied identifer
 @param identifier supplied identifier
 @return Success indicator as to whether the entry exists in the keychain
 */
+ (BOOL)doesObjectExistForIdentifier:(NSString *)identifier;

@end
