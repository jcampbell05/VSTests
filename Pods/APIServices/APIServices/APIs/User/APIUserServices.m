//
//  APIServices.m
//  APIServices
//
//  Created by William Boles on 08/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//
#import "APIUserServices.h"

#import <CoreServices/NSString+UFCEmpty.h>
#import <CoreAPIServices/CASRequestManager.h>
#import <CoreAPIServices/CASServiceManager.h>
#import <CoreAPIServices/CASSessionManager.h>

#import "APIMediaServices.h"

NSString * const kNewCommentKey = @"new_comment";
NSString * const kNewFavouriteKey = @"new_favourite";
NSString * const kNewFriendRequestKey = @"new_friend_request";
NSString * const kNewMessageKey = @"new_message";

@interface APIUserServices ()

@end

@implementation APIUserServices

#pragma mark - SignIn

+ (BFTask *)signInWithEmailAddress:(NSString *)emailAddress
                          password:(NSString *)password
{
    
    [[CASSessionManager sharedInstance] reset];

    /*-----------------------------*/
    
    NSDictionary *parameters = @{@"email" : emailAddress,
                                 @"password" : password,
                                 @"grant_type" : @"password",
                                 @"client_id" : [CASServiceManager sharedInstance].APIClientID,
                                 @"client_secret" : [CASServiceManager sharedInstance].APIClientSecret};
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/oauth/token"
                                  parameters:parameters
                           HTTPRequestMethod:CASHTTPRequestMethodPost
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [CASSessionManager sharedInstance].accessToken = responseObject[@"access_token"];
         
         [completion setResult:responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError:error];
     }];
    
    return  completion.task;
}

#pragma mark - SignOut

+ (BFTask *)signOut
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/oauth/token"
                           HTTPRequestMethod:CASHTTPRequestMethodDelete
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [[CASSessionManager sharedInstance] reset];
         
         [completion setResult:responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError:error];
     }];
    
    return  completion.task;
}

#pragma mark - SignUp

+ (BFTask *)signUpWithEmailAddress:(NSString *)emailAddress
                          password:(NSString *)password
                         firstName:(NSString *)firstName
                          lastName:(NSString *)lastName
{
    [[CASSessionManager sharedInstance] reset];
    
    /*-----------------------------*/
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:emailAddress
                   forKey:@"email"];
    
    [parameters setObject:password
                   forKey:@"password"];
    
    [parameters setObject:firstName
                   forKey:@"first_name"];
    
    if (lastName)
    {
        [parameters setObject:lastName
                       forKey:@"last_name"];
    }
    
    [parameters setObject:[CASServiceManager sharedInstance].APIClientID
                   forKey:@"client_id"];
    
    [parameters setObject:[CASServiceManager sharedInstance].APIClientSecret
                   forKey:@"client_secret"];
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/registrations"
                                  parameters:[parameters copy]
                           HTTPRequestMethod:CASHTTPRequestMethodPost
                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [CASSessionManager sharedInstance].accessToken = responseObject[@"access_token"];
         
         [completion setResult:responseObject];
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError:error];
     }];
    
    return completion.task;
}

#pragma mark - Profile

+ (BFTask *)retrieveProfile
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/users/me"
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

+ (BFTask *)retrieveProfileForUserID:(NSNumber *)userID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%@", userID];
    
    [CASRequestManager sendJSONRequestToPath:path
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

#pragma mark - FriendRequest

+ (BFTask *)sendFriendRequestToUserWithID:(NSNumber *)userID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *parameters = @{@"requested_id" : userID};
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/friend_requests"
                                  parameters:parameters
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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

#pragma mark - Retrieval

+ (BFTask *)retrieveFriendRequestsWithLimit:(NSNumber *)limit
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (limit)
    {
        [parameters setObject:limit
                       forKey:@"limit"];
    }
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/friend_requests"
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

+ (BFTask *)retrieveFriendRequestsWithNextPagePath:(NSString *)nextPagePath
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

#pragma mark - FriendRequestResponse

+ (BFTask *)sendFriendRequestResponseWithID:(NSNumber *)friendRequestID
                            requestResponse:(APIFriendRequestResponse)requestResponse
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/friend_requests/%@/transitions", friendRequestID];
    
    NSString *outcome = nil;
    
    switch (requestResponse)
    {
        case APIFriendRequestResponseApproval:
        {
            
            outcome = @"approve";
            
            break;
        }
        case APIFriendRequestResponseCancellation:
        {
            
            outcome = @"cancel";
            
            break;
        }
        case APIFriendRequestResponseRejection:
        {
            
            outcome = @"reject";
            
            break;
        }
        default:
            break;
    }
    
    NSDictionary *parameters = @{@"transition" : outcome};
    
    [CASRequestManager sendJSONRequestToPath:path
                                  parameters:parameters
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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

+ (BFTask *)acceptFriendRequestWithID:(NSNumber *)friendRequestID
{
    return [APIUserServices sendFriendRequestResponseWithID:friendRequestID
                                            requestResponse:APIFriendRequestResponseApproval];
}

+ (BFTask *)rejectFriendRequestWithID:(NSNumber *)friendRequestID
{
    return [APIUserServices sendFriendRequestResponseWithID:friendRequestID
                                            requestResponse:APIFriendRequestResponseRejection];
}

+ (BFTask *)cancelFriendRequestWithID:(NSNumber *)friendRequestID
{
    return [APIUserServices sendFriendRequestResponseWithID:friendRequestID
                                            requestResponse:APIFriendRequestResponseCancellation];
}

#pragma mark - Friends

+ (BFTask *)retrieveFriendsWithID:(NSNumber *)userID
                        withLimit:(NSNumber *)limit
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%@/friends", userID];
   
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (limit)
    {
        [parameters setObject:limit
                       forKey:@"limit"];
    }
    
    [CASRequestManager sendJSONRequestToPath:path
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

+ (BFTask *)retrieveFriendListWithNextPagePath:(NSString *)nextPagePath
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

#pragma mark - Unfriend

+ (BFTask *)unfriendWithID:(NSNumber *)friendID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/friends/%@", friendID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodDelete
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

#pragma mark - Search

+ (BFTask *)searchForUsersWithQuery:(NSString *)query
                              limit:(NSNumber *)limit
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (limit)
    {
        [parameters setObject:limit
                       forKey:@"limit"];
    }
    
    if (query.length > 0)
    {
        [parameters setObject:query
                       forKey:@"q"];
    }
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/users/search"
                                  parameters: parameters
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

+ (BFTask *)searchForUsersWithNextPageUrl:(NSString *)nextPageUrl
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToFullPath:nextPageUrl
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

+ (BFTask *)searchForCoursesForUniversityID:(NSNumber *)universityID withQuery:(NSString *)query
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *parameters = @{@"q" : query};
    NSString *path = [NSString stringWithFormat:@"/api/v1/universities/%@/courses", universityID];
    
    [CASRequestManager sendJSONRequestToPath:path
                                  parameters: parameters
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

+ (BFTask *)searchForUniversitiesWithQuery:(NSString *)query;
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *parameters = @{@"q" : query};
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/universities"
                                  parameters: parameters
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

#pragma mark - Photos

+ (BFTask *)retrieveUserPhotosWithID:(NSNumber *)userID
                     withNextPageUrl:(NSString *)nextPageUrl
                           withLimit:(NSNumber *)limit
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    if (nextPageUrl)
    {
        
        [CASRequestManager sendJSONRequestToFullPath:nextPageUrl
                                   HTTPRequestMethod:CASHTTPRequestMethodGet
                                             success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [completion setResult:responseObject];
         }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [completion setError:error];
         }];
    } else
    {
        
        NSString *path = [NSString stringWithFormat:@"/api/v1/users/%@/images?limit=%@", userID, limit];
        
        [CASRequestManager sendJSONRequestToPath:path
                               HTTPRequestMethod:CASHTTPRequestMethodGet
                                         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [completion setResult:responseObject];
         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [completion setError:error];
         }];
    }
    
    return completion.task;
}

#pragma mark - Avatar

+ (BFTask *)updateAvatar:(NSData *)data
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [[[APIMediaServices uploadMediaData:data mediaExtension:@"jpg"] continueWithSuccessBlock:^id(BFTask *task) {
        
        NSDictionary *newAvatar = @{ @"url": task.result };
        return [self updateProfile:@{ @"avatar" : newAvatar }];
        
    }] continueWithBlock:^id(BFTask *task) {
        
        if (task.error)
        {
            [completion setError: task.error];
        }
        else
        {
            [completion setResult: task.result];
        }
        
        return nil;
    }];
    
    return completion.task;
}

#pragma mark - Profile

+ (BFTask *)updateProfile:(NSDictionary *)data
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/users/me"
                                  parameters:data
                           HTTPRequestMethod:CASHTTPRequestMethodPut
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

#pragma mark - Settings

+ (BFTask *)retrieveSettings
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/users/me/settings"
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

+ (BFTask *)updateSettings:(NSDictionary *)data
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/users/me/settings"
                                  parameters:data
                           HTTPRequestMethod:CASHTTPRequestMethodPut
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

#pragma mark - Antisocial features

+ (BFTask *)blockUser:(NSNumber *)userID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/user_blocks"
                                  parameters: @{ @"blocked_id": userID }
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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

+ (BFTask *)unblockUser:(NSNumber *)userID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/user_blocks/%@", userID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodDelete
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

+ (BFTask *)muteUser:(NSNumber *)userID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%@/mute", userID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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

+ (BFTask *)unmuteUser:(NSNumber *)userID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/users/%@/mute", userID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodDelete
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

#pragma mark - Verification

+ (BFTask *)resendVerificationEmail
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/users/resend_confirmation_email"
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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


@end
