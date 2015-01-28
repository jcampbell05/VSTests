//
//  APICommentService.h
//  APIServices
//
//  Created by William Boles on 17/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

/**
 A collection of requests associated with comments
 */
@interface APICommentServices : NSObject

/**
 Retrieve comment page for post from last comemnt id
 
 @param post - post that comments are attached to
 @param lastComment - lastComment that client has for this post
 @param limit - limit of comments returned
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveCommentsForPostWithID:(NSNumber *)postID
                   afterLastCommentWithID:(NSNumber *)commentID
                                    limit:(NSNumber *)limit;

/**
 Retrieve comments for post
 
 @param post - post that comments are attached to
 @param limit - limit of comments returned
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveCommentsForPostWithID:(NSNumber *)postID
                                    limit:(NSNumber *)limit;


/**
 Retrieve comments for post from nextPagePath.
 
 Note: This service should NOT be called if nextPagePath is empty/nil.
 
 @param commentsNextPagePath - The next page path to retrieve next set of comments from API.
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveCommentsForPostWithNextPagePath:(NSString *)commentsNextPagePath;

/**
 Add comment to post
 
 @param postID - post comment will be added to
 @param status - status of comment
 
 @return BFTask for this operation
 */
+ (BFTask *)addCommentToPostWithID:(NSNumber *)postID
                            status:(NSString *)status;

/**
 Like a comment
 
 @param commentID - comment to be liked
 @param postID - post
 
 @return BFTask for this operation
 */
+ (BFTask *)addLikeToCommentWithID:(NSNumber *)commentID
                            postID:(NSNumber *)postID;

/**
 Remove like from comment
 
 @param commentID - comment to have like removed
 @param postID - post
 
 @return BFTask for this operation
 */
+ (BFTask *)removeLikeFromCommentWithID:(NSNumber *)commentID
                                 postID:(NSNumber *)postID;

@end
