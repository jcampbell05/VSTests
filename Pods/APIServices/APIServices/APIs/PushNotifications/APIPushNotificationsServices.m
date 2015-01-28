//
//  APIPushNotificationsServices.m
//  APIServices
//
//  Created by James Campbell on 06/08/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "APIPushNotificationsServices.h"

#import <CoreAPIServices/CASRequestManager.h>
#import <CoreAPIServices/CASKeyChainManager.h>

static NSString * const USNDeviceTokenIdentifier = @"USNDeviceTokenIdentifier";

@interface APIPushNotificationsServices ()

+ (NSString *)currentDeviceToken;
+ (NSString *)prepareDeviceToken:(NSData *)encodedDeviceToken;

@end

@implementation APIPushNotificationsServices

#pragma mark - Token

+ (NSString *)currentDeviceToken
{
    NSData *encodedDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:USNDeviceTokenIdentifier];
    NSString *deviceToken = [APIPushNotificationsServices prepareDeviceToken:encodedDeviceToken];
    
    return deviceToken;
}

+ (NSString *)prepareDeviceToken:(NSData *)encodedDeviceToken
{
    NSString *deviceTokenString = [[encodedDeviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return deviceTokenString;
}

#pragma mark - Register

+ (BFTask *)registerDeviceToken:(NSData *)encodedDeviceToken
{
    NSString *deviceToken = [APIPushNotificationsServices prepareDeviceToken:encodedDeviceToken];
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    if ([deviceToken isEqualToString:self.currentDeviceToken])
    {
        [completion setResult:nil];
    }
    else
    {
        [CASRequestManager sendJSONRequestToPath:@"/api/v1/devices"
                                      parameters:@{@"device_id": deviceToken}
                               HTTPRequestMethod:CASHTTPRequestMethodPost
                                         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:encodedDeviceToken forKey:USNDeviceTokenIdentifier];
             [userDefaults synchronize];
             
             [completion setResult:nil];
         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [completion setError:error];
         }];
    }
    
    return completion.task;
}

#pragma mark - Unregister

+ (BFTask *)unregisterDeviceToken
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/devices/%@", self.currentDeviceToken];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodDelete
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
         [userDefaults removeObjectForKey:USNDeviceTokenIdentifier];
         [userDefaults synchronize];
         
         [completion setResult:nil];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError:error];
     }];
    
    return completion.task;
}

@end
