//
//  CASServiceManager.h
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CASAuthenticationDelegate <NSObject>

/*
 This method would be invoked when a request fails with HTTP-401 status.
 Implementer should handle it to notify views of invalid user credentials and probably request user to re-login.
 */
- (void)handleUnauthorizedRequest;

@end

@protocol CASNetworkAvailabilityDelegate <NSObject>

/*
 This method would be invoked when a request fails with no internet.
 Implementer should handle it to notify views of the network un-availablity status.
 */
- (void)handleNoInternetAvailable;

/*
 This method would be invoked when a request is successful with internet.
 Implementer should handle it to notify views of the network availablity status.
 */
- (void)handleInternetAvailable;

@end

/**
 Configuration class in the app allowing for client specfic properties to be set
 */
@interface CASServiceManager : NSObject

/**
 The domain of the api that acts as api server
 
 This will be included in requests
 
 It's possible to override this value in instances where you need to connect to another domain by having your api call use the @see sendHTTPRequestToFullPath:parameters:HTTPRequestMethod:success:failure: method of @see CASRequestManager
 */
@property (nonatomic, strong) NSString *APIHost;

/**
 The client id that identifies your app with the server
 
 Works in tandem with @see APIClientSecret
 */
@property (nonatomic, strong) NSString *APIClientID;

/**
 The client sercet that identifies your app with the server
 
 Works in tandem with @see APIClientID
 */
@property (nonatomic, strong) NSString *APIClientSecret;

/**
 The authentication delegate which should handle authentication failure (HTTP 401) scenarios.
 
 */
@property (nonatomic, weak) id<CASAuthenticationDelegate> authenticationDelegate;

/**
 The network availability delegate which should handle no internet connection scenarios.
 
 */
@property (nonatomic, weak) id<CASNetworkAvailabilityDelegate> networkAvailabilityDelegate;

/**
 Singleton instance of this class
 */
+ (instancetype)sharedInstance;

/**
 Handles requests which failed with HTTP-401 status.
 */
- (void)handleUnauthorizedRequest;

/**
 Handles requests which failed with no internet availability - notifies networkAvailabilityDelegate to handle un-availability of internet.
 */
- (void)handleNoInternetAvailable;

/**
 Handles requests which were successful - notifies all networkAvailabilityDelegate to handle availability of internet.
 */
- (void)handleInternetAvailable;

@end
