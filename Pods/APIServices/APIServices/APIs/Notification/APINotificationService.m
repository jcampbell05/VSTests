//
//  APINotificationService.m
//  APIServices
//
//  Created by James Campbell on 14/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "APINotificationService.h"

#import <CoreAPIServices/CASRequestManager.h>

@implementation APINotificationService

#pragma mark - Retrieval

+ (BFTask *) retrieveNotificationsWithLimit:(NSNumber *)limit
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (limit)
    {
        [parameters setObject:limit
                       forKey:@"limit"];
    }
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/notifications"
                                  parameters:parameters
                           HTTPRequestMethod:CASHTTPRequestMethodGet
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [completion setResult:responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError:error];
     }];
    
    return completion.task;
}

+ (BFTask *) retrieveNotificationsWithNextPagePath:(NSString *)nextPagePath
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToFullPath:nextPagePath
                               HTTPRequestMethod:CASHTTPRequestMethodGet
                                         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [completion setResult:responseObject];
     }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError:error];
     }];
    
    return completion.task;
}

#pragma mark - Viewed

+ (BFTask *) markNotificationsAsViewed:(NSArray *)notificationsIDs
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *parameters = @{ @"ids": notificationsIDs };
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/notifications"
                                  parameters:parameters
                           HTTPRequestMethod:CASHTTPRequestMethodPut
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [completion setResult: responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError: error];
     }];
    
    return completion.task;
}

@end