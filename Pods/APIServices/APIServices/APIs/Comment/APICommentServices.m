//
//  APICommentService.m
//  APIServices
//
//  Created by William Boles on 17/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "APICommentServices.h"

#import <CoreAPIServices/CASRequestManager.h>

@implementation APICommentServices

#pragma mark - Retrieval

+ (BFTask *)retrieveCommentsForPostWithID:(NSNumber *)postID
                   afterLastCommentWithID:(NSNumber *)commentID
                                    limit:(NSNumber *)limit
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource  taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/comments?last_id=%@&limit=%@", postID, commentID, limit];
    
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

+ (BFTask *)retrieveCommentsForPostWithID:(NSNumber *)postID
                                    limit:(NSNumber *)limit
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/comments", postID];
    
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
         [completion setError: error];
     }];
    
    return completion.task;
}

+ (BFTask *)retrieveCommentsForPostWithNextPagePath:(NSString *)commentsNextPagePath
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToFullPath:commentsNextPagePath
                               HTTPRequestMethod:CASHTTPRequestMethodGet
                                         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [completion setResult:responseObject];
     }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [completion setError: error];
     }];
    
    return completion.task;
}

#pragma mark - Add

+ (BFTask *)addCommentToPostWithID:(NSNumber *)postID
                            status:(NSString *)status
{
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/comments", postID];
    
    NSDictionary *parameters = @{@"content" : status};
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendJSONRequestToPath:path
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

#pragma mark - Like

+ (BFTask *)addLikeToCommentWithID:(NSNumber *)commentID
                            postID:(NSNumber *)postID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/comments/%@/likes", postID, commentID];
    
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

+ (BFTask *)removeLikeFromCommentWithID:(NSNumber *)commentID
                                 postID:(NSNumber *)postID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/posts/%@/comments/%@/likes", postID, commentID];
    
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
