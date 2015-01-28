//
//  APINotificationService.h
//  APIServices
//
//  Created by James Campbell on 14/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@interface APINotificationService : NSObject

/**
 Retrieval user's notifications with limit.
 This fetches only first page of notifications with the given limit.
 The limit number would be used to construct the nextPageUrl by backend.
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveNotificationsWithLimit:(NSNumber *)limit;

/**
 Retrieval user's notifications. This fetches notifications using the nextPagePath provided.
 This should be called only when nextPagePath is neither nil nor empty.
 
 @param nextPagePath - Next Page Path to fetch next set of notifications
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveNotificationsWithNextPagePath:(NSString *)nextPagePath;

/**
 Marks notifications as viewed.
 
 @param notificaitons - array of ids for the notifications to mark as viewed.
 
 @return BFTask for this operation
 */
+ (BFTask *) markNotificationsAsViewed:(NSArray *)notificationsIDs;

@end
