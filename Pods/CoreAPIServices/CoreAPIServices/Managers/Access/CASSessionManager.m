//
//  CASSessionManager.m
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CASSessionManager.h"
#import "CASKeyChainManager.h"

static NSString * const kAccessToken = @"com.unii.accessToken";

static NSString * const kPreviouslyAuthenicatedWithAnotherInstall = @"previouslyAuthenicatedWithAnotherInstall";

@interface CASSessionManager ()

+ (NSString *)accessValueForIdentifier:(NSString *)identifier;

@end

@implementation CASSessionManager

@synthesize accessToken = _accessToken;

#pragma mark - Signleton

+ (instancetype)sharedInstance
{
    static CASSessionManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[CASSessionManager alloc] init];
                  });
    
    return sharedInstance;
}

#pragma mark - Access

- (NSString *)accessToken
{
    if (!_accessToken)
    {
        _accessToken = [CASSessionManager accessValueForIdentifier:kAccessToken];
    }
    
    return _accessToken;
}

- (void)setAccessToken:(NSString *)accessToken
{
    if (![_accessToken isEqualToString:accessToken])
    {
        [self willChangeValueForKey:@"accessToken"];
        
        _accessToken = accessToken;
        
        if (_accessToken)
        {
            //This is handle the scenerio where a user has previously auth with app and uninstalled and reinstalled app
            [[NSUserDefaults standardUserDefaults] setBool:YES
                                                    forKey:kPreviouslyAuthenicatedWithAnotherInstall];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSData *accessTokenData = [accessToken dataUsingEncoding:NSUTF8StringEncoding];
            [CASKeyChainManager setData:accessTokenData forIdentifier:kAccessToken];
        }
        else
        {
            [CASKeyChainManager deleteDataForIdentifier:kAccessToken];
        }
        
        [self didChangeValueForKey:@"accessToken"];
        
    }
}

#pragma mark - Reset

- (void)reset
{
    self.accessToken = nil;
    
    [CASKeyChainManager deleteDataForIdentifier:kAccessToken];
}

#pragma mark - Authenication

+ (NSString *)accessValueForIdentifier:(NSString *)identifier
{
    NSData *authenicationData = [CASKeyChainManager retrieveDataForIdentifier:identifier];
    
    NSString *authenicationString = nil;
    
    if (authenicationData)
    {
        authenicationString = [NSString stringWithUTF8String:[authenicationData bytes]];
    }
    
    return authenicationString;
}

#pragma mark - ValidateAccessToken

- (BOOL)isSessionValid
{
    BOOL isSessionValid = NO;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kPreviouslyAuthenicatedWithAnotherInstall])
    {
        isSessionValid = ([CASSessionManager sharedInstance].accessToken != nil);
    }
    else
    {
        [self reset];
    }
    
    return isSessionValid;
}
@end
