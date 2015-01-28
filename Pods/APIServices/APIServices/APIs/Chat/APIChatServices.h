//
//  APIChatServices.h
//  APIServices
//
//  Created by Ante Baus on 08/07/14.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@interface APIChatServices : NSObject

#pragma mark Contacts

/*
 Retrieves chat contacts for the searchCriteria and limit.
 
 If the searchCriteria is nil/Empty,
 then the default contact list [Friends, Friends-of-Friends, Classmates (Same Universiy, Same Course)]
 would be returned.
 
 @param searchCriteria - search criteria for chat contacts.
 @param limit - Number of contacts that should be fetched (Optional)
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveChatContactsWithSearchCriteria:(NSString *)searchCriteria
                                             limit:(NSNumber *)limit;

/**
 Retrieval chat contacts. This fetches chat contacts using the nextPageUrl provided.
 This should be called only when nextPageUrl is neither nil nor empty.
 
 @param nextPageUrl - Next Page Url to fetch next set of chat contacts
 
 @return BFTask for this operation
 */

+ (BFTask *)retrieveChatContactsWithNextPageUrl:(NSString*)nextPageUrl;

#pragma mark Converstations

/*
 Retrieves current user's conversations
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveConversations;

/*
 Retrieves current conversation with ID
 
 @param conversationID - Conversation ID
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveConversationWithJID:(NSString *)conversationJID;

/*
 Deletes conversation with JID
 
 @param conversationID - Conversation JID
 
 @return BFTask for this operation
 */
+ (BFTask *)removeConversationWithJID:(NSString *)conversationJID;

/*
 Hides conversation with JID
 
 @param conversationJID - Conversation JID
 
 @return BFTask for this operation
 */
+ (BFTask *)hideConversationWithJID:(NSString *)conversationJID;

#pragma mark Messages

/*
 Retrieves messages from specific conversation
 
 lastMessageId and limit are optional. If lastMessageId is not set, server will return latest messages.
 
 @param conversationID - Conversation ID
 @param lastMessageJID - xmpp_id of last message. If lastMessageId is not set, server will return latest messages. (Optional)
 @param limit - Number of messages that should be returned (Optional)
 
 @return BFTask for this operation
 */
+ (BFTask *)retrieveMessagesForConversationWithJID:(NSString *)conversationJID
                                    lastMessageJID:(NSString *)lastMessageJID
                                             limit:(NSNumber *)limit;

/*
 Deletes messages from specific conversation with message id
 
 @param conversationID - Conversation ID
 @param messageID - xmpp_id of message to delete
 
 @return BFTask for this operation
 */
+ (BFTask *)deleteMessageInConversationWithJID:(NSString *)conversationJID
                                    messageJID:(NSString *)messageJID;


/*
 Updates the messages with given ids as read
 
 @param conversationID - Conversation ID
 @param messageJIDs - collection of messages to set as read
 
 @return BFTask for this operation
 */
+ (BFTask *)markMessagesAsRead:(NSArray *)messageJIDs conversationWithJID:(NSString *)conversationJID;


@end
