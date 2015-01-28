//
//  CASRequestManager.m
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CASRequestManager.h"
#import "CASServiceManager.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "CASJSONRequestSerializer.h"
#import "CASJSONResponseSerializer.h"

@interface CASRequestManager ()

+ (void)sendRequestToFullPath:(NSString *)fullPath
                   parameters:(NSDictionary *)parameters
                multiPartData:(NSData *)multiPartData
            HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
      requestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
                      success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                     progress:(void(^)(float percentage, long long totalBytesProcessed, long long estimatedTotalBytes))progress
                      failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperationManager *)JSONRequestOperationManager;
+ (AFHTTPRequestOperationManager *)HTTPRequestOperationManager;

+ (void)handleFailedRequestOperation:(AFHTTPRequestOperation *)operation
                               error:(NSError *)error;
@end

@implementation CASRequestManager

#pragma mark - RequestOperationManager

+ (AFHTTPRequestOperationManager *)JSONRequestOperationManager
{
    AFHTTPRequestOperationManager *requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    requestOperationManager.requestSerializer = [CASJSONRequestSerializer serializer];
    requestOperationManager.responseSerializer = [CASJSONResponseSerializer serializer];
    
    return requestOperationManager;
}

+ (AFHTTPRequestOperationManager *)HTTPRequestOperationManager
{
    AFHTTPRequestOperationManager *requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return requestOperationManager;
}

#pragma mark - HandleFailedRequestOperationError

+ (void)handleFailedRequestOperation:(AFHTTPRequestOperation *)operation
                               error:(NSError *)error
{
    if (error.code == NSURLErrorNotConnectedToInternet)
    {
        // No Internet Connection.
        [[CASServiceManager sharedInstance] handleNoInternetAvailable];
    }
    else
    {
        if (operation.response.statusCode == 401)
        {
            [[CASServiceManager sharedInstance] handleUnauthorizedRequest];
        }
    }
}

#pragma mark - Request

+ (void)sendRequestToFullPath:(NSString *)fullPath
                   parameters:(NSDictionary *)parameters
                multiPartData:(NSData *)multiPartData
            HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
      requestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
                      success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                     progress:(void(^)(float percentage, long long totalBytesProcessed,  long long estimatedTotalBytes))progress
                      failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    /*-----------------------------*/
    
    switch (HTTPRequestMethod)
    {
        case CASHTTPRequestMethodGet:
        {
            
            AFHTTPRequestOperation *operation = [requestOperationManager GET:fullPath
                                                                  parameters:parameters
                                                                     success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                 {
                                                     [[CASServiceManager sharedInstance] handleInternetAvailable];
                                                     
                                                     if (success)
                                                     {
                                                         success(operation, responseObject);
                                                     }
                                                 }
                                                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                                 {
                                                     [CASRequestManager handleFailedRequestOperation:operation
                                                                                               error:error];
                                                     
                                                     if (failure)
                                                     {
                                                         failure(operation, error);
                                                     }
                                                 }];
            
            if (progress)
            {
                [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                 {
                     progress((float)totalBytesRead/totalBytesExpectedToRead, totalBytesRead, totalBytesExpectedToRead);
                 }];
            }
            
            break;
        }
        case CASHTTPRequestMethodPost:
        {
            AFHTTPRequestOperation *operation = nil;
            
            if (multiPartData)
            {
                operation = [requestOperationManager POST:fullPath
                                               parameters:parameters
                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                             {
                                 
                                 [formData appendPartWithFormData:multiPartData
                                                             name:@"file"];
                             }
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                             {
                                 [[CASServiceManager sharedInstance] handleInternetAvailable];
                                 
                                 if (success)
                                 {
                                     success(operation, responseObject);
                                 }
                             }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
                             {
                                 
                                 [CASRequestManager handleFailedRequestOperation:operation
                                                                           error:error];
                                 
                                 if (failure)
                                 {
                                     failure(operation, error);
                                 }
                             }];
            }
            else
            {
                operation = [requestOperationManager POST:fullPath
                                               parameters:parameters
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject)
                             {
                                 [[CASServiceManager sharedInstance] handleInternetAvailable];
                                 
                                 if (success)
                                 {
                                     success(operation, responseObject);
                                 }
                             }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
                             {
                                 [CASRequestManager handleFailedRequestOperation:operation
                                                                           error:error];
                                 
                                 if (failure)
                                 {
                                     failure(operation, error);
                                 }
                             }];
            }
            
            if (progress)
            {
                [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
                 {
                     progress((float)totalBytesWritten/totalBytesExpectedToWrite, totalBytesWritten, totalBytesExpectedToWrite);
                 }];
            }
            
            break;
        }
        case CASHTTPRequestMethodPut:
        {
            [requestOperationManager PUT:fullPath
                              parameters:parameters
                                 success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [[CASServiceManager sharedInstance] handleInternetAvailable];
                 
                 if (success)
                 {
                     success(operation, responseObject);
                 }
             }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [CASRequestManager handleFailedRequestOperation:operation
                                                           error:error];
                 
                 if (failure)
                 {
                     failure(operation, error);
                 }
             }];
            
            break;
        }
        case CASHTTPRequestMethodDelete:
        {
            
            [requestOperationManager DELETE:fullPath
                                 parameters:parameters
                                    success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 [[CASServiceManager sharedInstance] handleInternetAvailable];
                 
                 if (success)
                 {
                     success(operation, responseObject);
                 }
             }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 [CASRequestManager handleFailedRequestOperation:operation
                                                           error:error];
                 
                 if (failure)
                 {
                     failure(operation, error);
                 }
             }];
            
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - Request

+ (void)sendHTTPRequestToFullPath:(NSString *)fullPath
                       parameters:(NSDictionary *)parameters
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                           success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:parameters
                               multiPartData:nil
                           HTTPRequestMethod:HTTPRequestMethod
                     requestOperationManager:[self HTTPRequestOperationManager]
                                     success:success
                                    progress:nil
                                     failure:failure];
}

+ (void)sendHTTPRequestToFullPath:(NSString *)fullPath
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                          success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:nil
                               multiPartData:nil
                           HTTPRequestMethod:HTTPRequestMethod
                     requestOperationManager:[self HTTPRequestOperationManager]
                                     success:success
                                    progress:nil
                                     failure:failure];
}

+ (void)sendHTTPRequestToFullPath:(NSString *)fullPath
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                          success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                         progress:(void(^)(float percentage, long long totalBytesProcessed,  long long estimatedTotalBytes))progress
                          failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:nil
                               multiPartData:nil
                           HTTPRequestMethod:HTTPRequestMethod
                     requestOperationManager:[self HTTPRequestOperationManager]
                                     success:success
                                    progress:progress
                                     failure:failure];
}

+ (void)sendMultiPartHTTPRequestToFullPath:(NSString *)fullPath
                             multiPartData:(NSData *)multiPartData
                                parameters:(NSDictionary *)parameters
                                   success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  progress:(void(^)(float percentage, long long totalBytesProcessed,  long long estimatedTotalBytes))progress
                                   failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:parameters
                               multiPartData:multiPartData
                           HTTPRequestMethod:CASHTTPRequestMethodPost
                     requestOperationManager:[self HTTPRequestOperationManager]
                                     success:success
                                    progress:progress
                                     failure:failure];
}

+ (void)sendMultiPartHTTPRequestToFullPath:(NSString *)fullPath
                             multiPartData:(NSData *)multiPartData
                                parameters:(NSDictionary *)parameters
                                   success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:parameters
                               multiPartData:multiPartData
                           HTTPRequestMethod:CASHTTPRequestMethodPost
                     requestOperationManager:[self HTTPRequestOperationManager]
                                     success:success
                                    progress:nil
                                     failure:failure];
}

#pragma mark - JSON Requests

+ (void)sendJSONRequestToPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
            HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                      success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", [CASServiceManager sharedInstance].APIHost, path];
    
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:parameters
                               multiPartData:nil
                           HTTPRequestMethod:HTTPRequestMethod
                     requestOperationManager:[self JSONRequestOperationManager]
                                     success:success
                                    progress:nil
                                     failure:failure];
}

+ (void)sendJSONRequestToPath:(NSString *)path
            HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                      success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", [CASServiceManager sharedInstance].APIHost, path];
    
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:nil
                               multiPartData:nil
                           HTTPRequestMethod:HTTPRequestMethod
                     requestOperationManager:[self JSONRequestOperationManager]
                                     success:success
                                    progress:nil
                                     failure:failure];
}

+ (void)sendJSONRequestToFullPath:(NSString *)fullPath
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                          success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [CASRequestManager sendRequestToFullPath:fullPath
                                  parameters:nil
                               multiPartData:nil
                           HTTPRequestMethod:HTTPRequestMethod
                     requestOperationManager:[self JSONRequestOperationManager]
                                     success:success
                                    progress:nil
                                     failure:failure];
}
@end
