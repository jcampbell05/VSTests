//
//  NSObject+USNBlocks.m
//  Common
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "NSObject+UFCBlocks.h"

@implementation NSObject (UFCBlocks)

#pragma mark - Block

+ (void)ufc_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       
                       if (block)
                       {
                           block();
                       }
                       
                   });
}

- (void)ufc_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay
{
    [NSObject ufc_performBlock:block
                    afterDelay:delay];
}

@end
