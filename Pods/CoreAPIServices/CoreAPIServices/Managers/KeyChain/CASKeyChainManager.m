//
//  CASKeyChainManager.m
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CASKeyChainManager.h"
#import <Security/Security.h>

@interface CASKeyChainManager (Private)

+ (NSMutableDictionary *)newSearchDictionary: (NSString *)identifier;

@end

@implementation CASKeyChainManager

static NSString * const kKeyChainServiceName = @"com.unii";

#pragma mark - Retrieval

+ (NSMutableDictionary *)newSearchDictionary: (NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:kKeyChainServiceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}


+ (NSData *)retrieveDataForIdentifier:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDictionaryRef cfquery = (__bridge_retained CFDictionaryRef)searchDictionary;
    CFDictionaryRef cfresult = NULL;
    OSStatus status = SecItemCopyMatching(cfquery, (CFTypeRef *)&cfresult);
    CFRelease(cfquery);
    
    NSData *result = nil;
    
    if (status == errSecSuccess)
    {
        result = (__bridge_transfer NSData *)cfresult;;
    }
    
    return result;
    
}

+ (BOOL)doesObjectExistForIdentifier:(NSString *)identifier
{
    BOOL doesObjectExistForIdentifier = NO;
    
    if ([self retrieveDataForIdentifier:identifier])
    {
        doesObjectExistForIdentifier = YES;
    }
    
    return doesObjectExistForIdentifier;
}

#pragma mark - Creation

+ (BOOL)setData:(NSData *)data forIdentifier:(NSString *)identifier
{
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    [dictionary setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    BOOL dataSet = NO;
    
    if(status == errSecSuccess)
    {
        dataSet = YES;
    }
    
    return dataSet;
    
}

#pragma mark - Updating

+ (BOOL)updateData:(NSData *)data identifier:(NSString *)identifier
{
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    
    [updateDictionary setObject:data forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);
    
    BOOL dataUpdated = NO;
    
    if (status == errSecSuccess)
    {
        dataUpdated = YES;
    }
    else
    {
        dataUpdated = [self setData:data forIdentifier:identifier];
    }
    
    return dataUpdated;
}

#pragma mark - Deletion

+ (void)deleteDataForIdentifier:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
    
}

@end
