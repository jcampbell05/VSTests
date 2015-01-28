//
//  APIMediaServices.h
//  APIServices
//
//  Created by William Boles on 23/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

extern NSString *APIMediaDataKey;
extern NSString *APIMediaExtensionKey;

/**
 A collection of requests associated with pushing media (the actual files not the class - APIMedia) to the server
 */
@interface APIMediaServices : NSObject

/**
 Retrieves media end point details for a particular extension
 
 @param mediaExtension - extension of media file
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveMediaEndPointForMediaWithExtension:(NSString *)mediaExtension;

/**
 Upload media data to an end point (combination of both 'retrieveMediaEndPointForMediaWithExtension:success:failure' and 'uploadMediaData:mediaEndPoint:parameters:success:failure')
 
 @param mediaData - media to be uploaded
 @param mediaExtension - path that media be sent to
 
 @return BFTask for this operation.
 */
+ (BFTask *)uploadMediaData:(NSData *)mediaData
             mediaExtension:(NSString *)mediaExtension;

/**
 Upload an array of media to an endpoint. (combination of both 'retrieveMediaEndPointForMediaWithExtension:success:failure' and 'uploadMediaData:mediaEndPoint:parameters:success:failure')
 
 @param mediaToUpload - array of sictionarys containing media information.
 
 @return BFTask for this operation.
 */
+ (BFTask *)uploadMediaData:(NSArray *)mediaToUpload
                   progress:(NSProgress *)progress;

/**
 Retrieve media data from url
 
 @param mediaEndPoint - path that media will be retrieved from

 @return BFTask for this operation.
 */
+ (BFTask *)retrieveMediaFromEndPoint:(NSString *)mediaEndPoint;


@end
