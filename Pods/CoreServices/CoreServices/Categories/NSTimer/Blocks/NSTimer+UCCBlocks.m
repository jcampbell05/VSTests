//
//  NSTimer+UCCBlocks.m
//  CoreServices
//
//  Created by William Boles on 09/06/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "NSTimer+UCCBlocks.h"

@implementation NSTimer (UCCBlocks)

#pragma mark - Schedule

+ (NSTimer *) ucc_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                           block:(void (^)(void))block
                                         repeats:(BOOL)repeats
{
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                            target:self
                                          selector:@selector(ucc_timerSelector:)
                                          userInfo:[block copy]
                                           repeats:repeats];
}

+ (void) ucc_timerSelector:(NSTimer *)timer
{
    void (^block)(void) = timer.userInfo;
    
    if (block)
    {
        block();
    }
    
}

@end
