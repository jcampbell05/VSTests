//
//  NSObject+USNBlocks.h
//  Common
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (USNBlocks)

/*
 Executes block after a delay
 
 @param block - block to be executed
 @param delay - time delay before block is executed
 */
- (void)ufc_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay;

/*
 Executes block after a delay
 
 @param block - block to be executed
 @param delay - time delay before block is executed
 */
+ (void)ufc_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay;

@end
