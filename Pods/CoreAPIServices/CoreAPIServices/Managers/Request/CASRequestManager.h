//
//  CASRequestManager.h
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

/**
 Used to determine what type of HTTP request is being sent
 */
typedef NS_ENUM(NSUInteger, CASHTTPRequestMethod)
{
    CASHTTPRequestMethodGet = 0,
    CASHTTPRequestMethodPost = 1,
    CASHTTPRequestMethodPut = 2,
    CASHTTPRequestMethodDelete,
};

/**
 Responsible for integrating with networking layer to make requests to the server
 */
@interface CASRequestManager : NSObject

/**
 Send a HTTP request
 
 Responsible for adding any global headers to request
 
 @param fullPath - full path to resource on server
 @param parameters - http request body
 @param HTTPRequestMethod - determines which type of http request is created
 @param success - block called when request was successful
 @param failure - block called when request failed with an error
 */
+ (void)sendHTTPRequestToFullPath:(NSString *)fullPath
                       parameters:(NSDictionary *)parameters
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                          success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Send a HTTP request
 
 Responsible for adding any global headers to request
 
 @param fullPath - full path to resource on server
 @param HTTPRequestMethod - determines which type of http request is created
 @param success - block called when request was successful
 @param failure - block called when request failed with an error
 */
+ (void)sendHTTPRequestToFullPath:(NSString *)fullPath
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                          success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Send a HTTP request
 
 Responsible for adding any global headers to request
 
 @param fullPath - full path to resource on server
 @param HTTPRequestMethod - determines which type of http request is created
 @param success - block called when request was successful
 @param progress - block called when progress is made on uploading
 @param failure - block called when request failed with an error
 */
+ (void)sendHTTPRequestToFullPath:(NSString *)fullPath
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                          success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                         progress:(void(^)(float percentage, long long totalBytesProcessed,  long long estimatedTotalBytes))progress
                          failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Send a multipart HTTP request
 
 @param path - full path to resource
 @param data - data which will be posted
 @param parameters - http request body
 @param success - block called when request was successful
 @param failure - block called when request failed with an error
 */
+ (void)sendMultiPartHTTPRequestToFullPath:(NSString *)fullPath
                             multiPartData:(NSData *)multiPartData
                                parameters:(NSDictionary *)parameters
                                   success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Send a multipart HTTP request
 
 @param path - full path to resource
 @param data - data which will be posted
 @param parameters - http request body
 @param success - block called when request was successful
 @param progress - block called when progress is made on uploading
 @param failure - block called when request failed with an error
 */
+ (void)sendMultiPartHTTPRequestToFullPath:(NSString *)fullPath
                             multiPartData:(NSData *)multiPartData
                                parameters:(NSDictionary *)parameters
                                   success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  progress:(void(^)(float percentage, long long totalBytesProcessed,  long long estimatedTotalBytes))progress
                                   failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Send a JSON request
 
 @param path - path to resource on server (will be combined with APIHost value to form full url)
 @param parameters - http request body
 @param HTTPRequestMethod - determines which type of http request is created
 @param success - block called when request was successful
 @param failure - block called when request failed with an error
 */
+ (void)sendJSONRequestToPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
            HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                      success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Send a JSON request
 
 @param path - path to resource on server (will be combined with APIHost value to form full url)
 @param HTTPRequestMethod - determines which type of http request is created
 @param success - block called when request was successful
 @param failure - block called when request failed with an error
 */
+ (void)sendJSONRequestToPath:(NSString *)path
            HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                      success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Send a JSON request
 
 @param fullPath - full path to resource on server
 @param HTTPRequestMethod - determines which type of http request is created
 @param success - block called when request was successful
 @param failure - block called when request failed with an error
 */
+ (void)sendJSONRequestToFullPath:(NSString *)fullPath
                HTTPRequestMethod:(CASHTTPRequestMethod)HTTPRequestMethod
                          success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
