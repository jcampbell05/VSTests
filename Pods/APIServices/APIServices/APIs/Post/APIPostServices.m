//
//  APIPostServices.m
//  APIServices
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "APIPostServices.h"

#import <CoreAPIServices/CASRequestManager.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface APIPostServices ()

@end

@implementation APIPostServices

#pragma mark - RetrievalPostsForUser

+ (BFTask *)retrievePostsForUser:(NSNumber *)userID
                       withLimit:(NSNumber *)limit
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSMutableString *path = [NSMutableString stringWithFormat:@"/api/v1/users/%@/posts?limit=%@", userID, limit];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodGet
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

#pragma mark - RetrievePostsWithNextPageUrl

+ (BFTask *)retrievePostsWithNextPageUrl:(NSString *)nextPageUrl
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

#pragma mark - RetrieveNowPostsWithLimit

+ (BFTask *)retrieveNowPostsWithLimit:(NSNumber *)limit
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts?limit=%@", limit];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodGet
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

#pragma mark - AddPostWithStatus

+ (BFTask *)addPostWithStatus:(NSString *)status
                    mediaURLs:(NSArray *)mediaURLs
{
    NSMutableArray *mediaDictionaries = [NSMutableArray arrayWithCapacity:[mediaURLs count]];
    
    for (NSString *mediaURL in mediaURLs)
    {
        NSString *type = nil;
        
        CFStringRef fileExtension = (__bridge CFStringRef) [mediaURL pathExtension];
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        
        if (UTTypeConformsTo(fileUTI, kUTTypeImage))
        {
            type = @"Image";
        }
        else if (UTTypeConformsTo(fileUTI, kUTTypeMovie))
        {
            type = @"Video";
        }
        else
        {
            type = @"Link";
        }
        
        NSDictionary *mediaParameters = @{@"type" : type,
                                          @"url" : mediaURL};
        
        [mediaDictionaries addObject:mediaParameters];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (status)
    {
        [parameters setObject:status
                       forKey:@"content"];
    }
    
    if ([mediaDictionaries count] > 0)
    {
        [parameters setObject:[mediaDictionaries copy]
                       forKey:@"medias"];
    }

    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/posts"
                                  parameters:parameters
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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

#pragma mark - AddLikeToPostWithID

+ (BFTask *)addLikeToPostWithID:(NSNumber *)postID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/likes", postID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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

#pragma mark - RemoveLikeFromPostWithID

+ (BFTask *)removeLikeFromPostWithID:(NSNumber *)postID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/likes", postID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodDelete
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

#pragma mark - RetrieveLikesFromPostWithID

+ (BFTask *)retrieveLikesFromPostWithID:(NSNumber *)postID
                              withLimit:(NSNumber *)limit;
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (limit)
    {
        [parameters setObject:limit
                       forKey:@"limit"];
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/likes", postID];
    
    [CASRequestManager sendJSONRequestToPath:path
                                  parameters:parameters
                           HTTPRequestMethod:CASHTTPRequestMethodGet
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

+ (BFTask *)retrieveLikesFromPostWithNextPageUrl:(NSString *)nextPageUrl
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

#pragma mark - Report

+ (BFTask *)reportPostWithID:(NSNumber *)postID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/report", postID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodPost
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

#pragma mark - Remove

+ (BFTask *)removePostWithID:(NSNumber *)postID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@", postID];
    
    [CASRequestManager sendJSONRequestToPath:path
                           HTTPRequestMethod:CASHTTPRequestMethodDelete
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
