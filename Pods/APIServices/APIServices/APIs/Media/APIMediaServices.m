//
//  APIMediaServices.m
//  APIServices
//
//  Created by William Boles on 23/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "APIMediaServices.h"

#import <CoreAPIServices/CASRequestManager.h>

NSString *APIMediaDataKey = @"APIMediaDataKey";
NSString *APIMediaExtensionKey = @"APIMediaExtensionKey";

@interface APIMediaServices ()

+ (BFTask *)uploadMediaData:(NSData *)mediaData
              mediaEndPoint:(NSString *)mediaEndPoint
                 parameters:(NSDictionary *)parameters;

@end

@implementation APIMediaServices

#pragma mark - EndPoint

+ (BFTask *)retrieveMediaEndPointForMediaWithExtension:(NSString *)mediaExtension
{
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    NSDictionary *parameters = @{@"extension" : mediaExtension};
    
    [CASRequestManager sendJSONRequestToPath:@"/api/v1/uploads"
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

+ (BFTask *)retrieveMediaFromEndPoint:(NSString *)mediaEndPoint
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendHTTPRequestToFullPath:mediaEndPoint
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

#pragma mark - Upload

+ (BFTask *)uploadMediaData:(NSData *)mediaData
              mediaEndPoint:(NSString *)mediaEndPoint
                 parameters:(NSDictionary *)parameters
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    
    [CASRequestManager sendMultiPartHTTPRequestToFullPath:mediaEndPoint
                                            multiPartData:mediaData
                                               parameters:parameters
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [completion setResult:nil];
    }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [completion setError:error];
    }];
    
    return completion.task;
}

+ (BFTask *)uploadMediaData:(NSData *)mediaData
              mediaExtension:(NSString *)mediaExtension
{
    
    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    __block NSString *mediaEndPointURL;
    
    [[[APIMediaServices retrieveMediaEndPointForMediaWithExtension:[mediaExtension lowercaseString]] continueWithSuccessBlock:^id(BFTask *task)
    {
        
        NSDictionary *endPointDetails = task.result;
        
        NSString *mediaUploadURL = endPointDetails[@"url"];
        NSDictionary *staticFields = endPointDetails[@"static_fields"];
        mediaEndPointURL = endPointDetails[@"final_location"];
        
        return [APIMediaServices uploadMediaData:mediaData
                                   mediaEndPoint:mediaUploadURL
                                      parameters:staticFields];
        
    }]
     continueWithBlock:^id(BFTask *task)
    {
        
        if (task.error)
        {
            [completion setError:task.error];
        }
        else
        {
            [completion setResult:mediaEndPointURL];
        }
        
        return nil;
    }];
    
    return completion.task;
}

+ (BFTask *)uploadMediaData:(NSArray *)mediaToUpload
                   progress:(NSProgress *)progress
{
    
    progress.totalUnitCount = mediaToUpload.count;

    BFTaskCompletionSource *completion = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *tasks = [[NSMutableArray alloc] init];
    NSMutableArray *uploadedMedia = [[NSMutableArray alloc] init];
    
    for (NSDictionary *media in mediaToUpload)
    {
        
        BFTask *task = [[self uploadMediaData:media[APIMediaDataKey]
                               mediaExtension:media[APIMediaExtensionKey]] continueWithSuccessBlock:^id(BFTask *task)
        {
            progress.completedUnitCount++;
            [uploadedMedia addObject:task.result];
            return nil;
        }];
        
        [tasks addObject:task];
    }
    
    [[BFTask taskForCompletionOfAllTasks: tasks] continueWithBlock:^id(BFTask *task)
    {
       
        if (task.error)
        {
            [completion setError:task.error];
        }
        else
        {
            [completion setResult:uploadedMedia];
        }
        
        return nil;
    }];
    
    return completion.task;
}

@end
