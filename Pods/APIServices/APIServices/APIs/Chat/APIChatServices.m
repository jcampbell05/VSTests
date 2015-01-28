//
//  APIChatServices.m
//  APIServices
//
//  Created by Ante Baus on 08/07/14.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "APIChatServices.h"

#import <CoreAPIServices/CASRequestManager.h>

@implementation APIChatServices

#pragma mark - Contacts

+ (BFTask *)retrieveChatContactsWithSearchCriteria:(NSString *)searchCriteria
                                             limit:(NSNumber *)limit
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = @"/api/v1/users/me/chat_contacts";
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    if (limit)
    {
        [parameters setObject:limit
                       forKey:@"limit"];
    }
    
    if (searchCriteria.length > 0)
    {
        [parameters setObject:searchCriteria
                       forKey:@"q"];
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

+ (BFTask *)retrieveChatContactsWithNextPageUrl:(NSString *)nextPageUrl
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

#pragma mark - Converstations

+ (BFTask *)retrieveConversations
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = @"/api/v1/conversations";
    
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

+ (BFTask *)retrieveConversationWithJID:(NSString *)conversationJID
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/conversations/%@", conversationJID];
    
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

+ (BFTask *)removeConversationWithJID:(NSString *)conversationJID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/conversations/%@", conversationJID];
    
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

+ (BFTask *)hideConversationWithJID:(NSString *)conversationJID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/conversations/%@/hide", conversationJID];
    
    [CASRequestManager sendJSONRequestToPath:path
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

#pragma mark - Messages

+ (BFTask *)retrieveMessagesForConversationWithJID:(NSString *)conversationJID
                                    lastMessageJID:(NSString *)lastMessageJID
                                             limit:(NSNumber *)limit
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/conversations/%@/messages", conversationJID];
    
    if (lastMessageJID.length > 0 ||
        limit)
    {
        path = [path stringByAppendingString:@"?"];
        
        if (lastMessageJID)
        {
            path = [path stringByAppendingString:[NSString stringWithFormat:@"last_xmpp_id=%@", lastMessageJID]];
        }
        
        if (limit)
        {
            if (![[path substringFromIndex:path.length - 1] isEqualToString:@"?"])
            {
                path = [path stringByAppendingString:@"&"];
            }
            
            path = [path stringByAppendingString:[NSString stringWithFormat:@"limit=%@", limit]];
        }
    }
    
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

+ (BFTask *)deleteMessageInConversationWithJID:(NSString *)conversationJID
                                    messageJID:(NSString *)messageJID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/conversations/%@/messages/%@", conversationJID, messageJID];
    
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

+ (BFTask *)markMessagesAsRead:(NSArray *)messageJIDs conversationWithJID:(NSString *)conversationJID
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    NSDictionary *parameters = @{@"ids" : messageJIDs};
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/conversations/%@/messages", conversationJID];
    
    [CASRequestManager sendJSONRequestToPath:path
                                  parameters:parameters
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

@end
