//
//  APIPostServices.h
//  APIServices
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@class APIPost;

/**
 A collection of requests associated with posts
 */
@interface APIPostServices : NSObject

/**
 Retrieves posts for user.
 
 @param user - the user the posts are for
 @param limit - number of posts that should be returned
 
 @return BFTask for this operation
 */
+ (BFTask *)retrievePostsForUser:(NSNumber *)userID
                       withLimit:(NSNumber *)limit;

/**
 Retrieval user's/now posts. This fetches posts using the nextPageUrl provided.
 This should be called only when nextPageUrl is neither nil nor empty.
 
 @param nextPageUrl - Next Page Url to fetch next set of notifications
 
 @return BFTask for this operation
 */
+ (BFTask *)retrievePostsWithNextPageUrl:(NSString *)nextPageUrl;

/**
 Retrieve posts for Now.
 
 @param limit - number of posts that should be on a page
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveNowPostsWithLimit:(NSNumber *)limit;

/**
 Add post
 
 @param status - post status
 @param medias - associated media
 
 @return BFTask for this operation
 */
+ (BFTask *)addPostWithStatus:(NSString *)status
                    mediaURLs:(NSArray *)mediaURLs;

/**
 Like a post
 
 @param postID - post to be liked
 
 @return BFTask for this operation
 */
+ (BFTask *)addLikeToPostWithID:(NSNumber *)postID;


/**
 Remove like from post
 
 @param post - post to have like removed
 
 @return BFTask for this operation
 */
+ (BFTask *)removeLikeFromPostWithID:(NSNumber *)postID;

/**
 Retrieve users who have liked a post
 
 @param postID - corresponds to a post
 
 @param limit - number of likes that should be on a page
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveLikesFromPostWithID:(NSNumber *)postID
                              withLimit:(NSNumber *)limit;

/**
 Retrieve users who have liked a post using the nextPageUrl provided.
 This should be called only when nextPageUrl is neither nil nor empty.
 
 @param nextPageUrl - Next Page Url to fetch next set of likes
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveLikesFromPostWithNextPageUrl:(NSString *)nextPageUrl;

/**
 Reports the post as malicius
 
 @param postID - corresponds to a post
 
 @return BFTask for this operation
 */
+ (BFTask *)reportPostWithID:(NSNumber *)postID;

/**
 Removes the post
 
 @param postID - corresponds to a post
 
 @return BFTask for this operation
 */
+ (BFTask *)removePostWithID:(NSNumber *)postID;

@end
