//
//  CASServiceManager.m
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CASServiceManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "CASSessionManager.h"

@implementation CASServiceManager

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static CASServiceManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[CASServiceManager alloc] init];
                      [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
                  });
    
    return sharedInstance;
}

#pragma mark - HandleUnauthorizedRequest

- (void)handleUnauthorizedRequest
{
    [[CASSessionManager sharedInstance] reset];
    
    [self.authenticationDelegate handleUnauthorizedRequest];
}

#pragma mark - HandleNoInternetAvailable

- (void)handleNoInternetAvailable
{
    [self.networkAvailabilityDelegate handleNoInternetAvailable];
}

#pragma mark - HandleInternetAvailable

- (void)handleInternetAvailable
{
    
    [self.networkAvailabilityDelegate handleInternetAvailable];
}
@end
