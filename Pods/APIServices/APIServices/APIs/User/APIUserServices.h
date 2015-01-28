//
//  APIServices.h
//  APIServices
//
//  Created by William Boles on 08/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

/**
 Key for a new comment.
 */
extern NSString * const kNewCommentKey;

/**
 Key for a new favourite.
 */
extern NSString * const kNewFavouriteKey;
extern NSString * const kNewFriendRequestKey;
extern NSString * const kNewMessageKey;

@class APIUser;


typedef NS_ENUM(NSUInteger, APIFriendRequestResponse)
{
    APIFriendRequestResponseApproval = 0,
    APIFriendRequestResponseRejection = 1,
    APIFriendRequestResponseCancellation = 2,
};

/**
 A collection of requests associated with user's accounts
 */
@interface APIUserServices : NSObject

/**
 Sign-in user into their account
 
 @param emailAddress - emailAddress associated with user
 @param password - used to verify that the user should have access to this account
 
 @return BFTask for this operation
 */
+ (BFTask *)signInWithEmailAddress:(NSString *)emailAddress
                          password:(NSString *)password;

/**
 Sign-out user from their account
 
 @return BFTask for this operation
 */
+ (BFTask *)signOut;

/**
 Sign-up user
 
 @param emailAddress - emailAddress associated with user
 @param password - used to verify that the user should have access to this account
 @param firstName - firstname associated with user
 @param lastName - lastname associated with user (optional)
 
 @return BFTask for this operation
 */
+ (BFTask *)signUpWithEmailAddress:(NSString *)emailAddress
                          password:(NSString *)password
                         firstName:(NSString *)firstName
                          lastName:(NSString *)lastName;

/**
 Retrieve a user's profile
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveProfile;

/**
 Retrieve a user's profile
 
 @param userID - ID of user that we want the profile details for
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveProfileForUserID:(NSNumber *)userID;

/**
 Send friend request to user
 
 @param userID - ID of user that will receive friend request
 
 @return BFTask for this operation
 */
+ (BFTask *)sendFriendRequestToUserWithID:(NSNumber *)userID;

/**
 Retrieval friend requests for user
 This fetches only first page of friend requests with the given limit.
 The limit number would be used to construct the nextPageUrl by backend.
 
 @param limit - limit number of friend requests fetched from server.
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveFriendRequestsWithLimit:(NSNumber *)limit;

/**
 Retrieval friend requests for user
 This fetches friend requests using the nextPagePath provided.
 This should be called only when nextPagePath is neither nil nor empty.
 
 @param nextPagePath - Next Page Path to fetch next set of notifications
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveFriendRequestsWithNextPagePath:(NSString *)nextPagePath;

/**
 Friend request responses
 
 @param friendRequestID - ID of friend request
 
 @return BFTask for this operation
 */
+ (BFTask *)sendFriendRequestResponseWithID:(NSNumber *)friendRequestID
                            requestResponse:(APIFriendRequestResponse)requestResponse;

/**
 Accept friend request
 
 @param friendRequestID - ID of friend request
 
 @return BFTask for this operation
 */
+ (BFTask *)acceptFriendRequestWithID:(NSNumber *)friendRequestID;

/**
 Reject friend request
 
 @param friendRequestID - ID of friend request
 
 @return BFTask for this operation
 */
+ (BFTask *)rejectFriendRequestWithID:(NSNumber *)friendRequestID;

/**
 Cancel friend request
 
 @param friendRequestID - ID of friend request
 
 @return BFTask for this operation
 */
+ (BFTask *)cancelFriendRequestWithID:(NSNumber *)friendRequestID;

/**
 Retrieval friends for user, this method is called only the first time friends are requested
 
 @param userID - ID of user that users returned are friends with
 @param limit - number of posts that should be on a page
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveFriendsWithID:(NSNumber *)userID
                        withLimit:(NSNumber *)limit;

/**
 Retrieval user's Friend List. This fetches friends using the nextPagePath provided.
 This should be called only when nextPagePath is neither nil nor empty.
 
 @param nextPagePath - Next Page Path to fetch next list of friends
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveFriendListWithNextPagePath:(NSString *)nextPagePath;

/**
 Unfriend an existing friend
 
 @param friendID - ID of friend
 
 @return BFTask for this operation
 */
+ (BFTask *)unfriendWithID:(NSNumber *)friendID;

/**
 Search for a user.
 
 @param query - Query string.
 @param limit - maximum number of users that can be returned by the search.
 
 @return BFTask for this operation
 */
+ (BFTask *)searchForUsersWithQuery:(NSString *)query
                              limit:(NSNumber *)limit;

/**
 Search for a user.
 
 @param nextPageUrl - URL to download the following results.
 
 @return BFTask for this operation
 */
+ (BFTask *)searchForUsersWithNextPageUrl:(NSString *)nextPageUrl;

/**
 Search for courses.
 
 @param query - Query string.
 
 @return BFTask for this operation
 */
+ (BFTask *)searchForCoursesForUniversityID:(NSNumber *)universityID
                                  withQuery:(NSString *)query;

/**
 Search for universities.
 
 @param query - Query string.
 
 @return BFTask for this operation
 */
+ (BFTask *)searchForUniversitiesWithQuery:(NSString *)query;

/**
 Retrieval user's photos
 
 @param userID - ID of user that the photos belong to
 @param nextPageUrl - Next Page Url to fetch next set of photos
 @param limit - number of posts that should be on a page
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveUserPhotosWithID:(NSNumber *)userID
                     withNextPageUrl:(NSString *)nextPageUrl
                           withLimit:(NSNumber *)limit;

/*!
 Update avatar for user.
 
 @param data Image data for the avatar.
 
 @return BFTask for this operation
 */
+ (BFTask *)updateAvatar:(NSData *)data;

/*!
 Updates profile for user.
 
 @param data new profile data for user.
 
 @return BFTask for this operation.
 */
+ (BFTask *)updateProfile:(NSDictionary *)data;

/*!
 Retrieval of settings for user.
 
 @return BFTask for this operation.
 */
+ (BFTask *)retrieveSettings;

/*!
 Updates settings for user.
 
 @param settings new settings for user.
 
 @return BFTask for this operation.
 */
+ (BFTask *)updateSettings:(NSDictionary *)data;

/*!
 Blocks a user.
 
 @param userID - ID of user to block.
 
 @return BFTask for this operation.
 */
+ (BFTask *)blockUser:(NSNumber *)userID;

/*!
 Unblocks a user.
 
 @param userID - ID of user to unblock.
 
 @return BFTask for this operation.
 */
+ (BFTask *)unblockUser:(NSNumber *)userID;

/*!
 Mutes a user.
 
 @param userID - ID of user to mute.
 
 @return BFTask for this operation.
 */
+ (BFTask *)muteUser:(NSNumber *)userID;

/*!
 Unmutes a user.
 
 @param userID - ID of user to unmute.
 
 @return BFTask for this operation.
 */
+ (BFTask *)unmuteUser:(NSNumber *)userID;

/*!
 Resends verification email to user's university email address
 
 @return BFTask for this operation.
 */
+ (BFTask *)resendVerificationEmail;

@end
