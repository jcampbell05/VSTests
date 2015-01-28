//
//  APIPushNotificationsServices.h
//  APIServices
//
//  Created by James Campbell on 06/08/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@interface APIPushNotificationsServices : NSObject

/**
 Registers Device token for push notifications
 
 @param deviceToken - device token.
 
 @return BFTask for this operation
 */
+ (BFTask *)registerDeviceToken:(NSData *)deviceToken;

/**
 Unregisters Device token for push notifications
 
 @return BFTask for this operation
 */
+ (BFTask *)unregisterDeviceToken;

@end
