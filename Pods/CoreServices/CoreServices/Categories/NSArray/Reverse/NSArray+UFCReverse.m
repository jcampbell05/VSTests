//
//  NSArray+UFCReverse.m
//  Common
//
//  Created by William Boles on 21/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "NSArray+UFCReverse.h"

@implementation NSArray (UFCReverse)

#pragma mark - Reverse

+ (NSArray *) ufc_reversedArray:(NSArray *)reverseArray
{
    NSMutableArray *reversedArray = nil;
    
    if (reverseArray)
    {
        reversedArray = [NSMutableArray arrayWithCapacity:[reverseArray count]];
        
        NSEnumerator *enumerator = [reverseArray reverseObjectEnumerator];
        
        for (id element in enumerator)
        {
            [reversedArray addObject:element];
        }
    }
    
    return [reversedArray copy];
}

- (NSArray *) ufc_reversedArray
{
    return [NSArray ufc_reversedArray:self];
}

@end
