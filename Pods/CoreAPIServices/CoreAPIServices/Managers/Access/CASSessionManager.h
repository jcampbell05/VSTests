//
//  CASSessionManager.h
//  CASServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Responsible for storing and retrieving user's access values
 */
@interface CASSessionManager : NSObject

/**
 The token provided upon a successful authorization attempt
 */
@property (nonatomic, strong) NSString *accessToken;

/**
 Singleton instance of this class
 */
+ (instancetype)sharedInstance;

/*
 Destroys associated access data  
 */
- (void)reset;

/*
 Checks whether the accessToken is still valid.
 
 @return flag to indicate if session is valid
 */
- (BOOL)isSessionValid;

@end
