//
//  NSString+Empty.m
//  Common
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "NSString+UFCEmpty.h"

@implementation NSString (UFCEmpty)

#pragma mark - Empty

- (BOOL) ufc_isEmpty
{
    return [NSString ufc_isEmpty:self];
}

+ (BOOL) ufc_isEmpty:(NSString *)string
{
    BOOL isStringEmpty = YES;
    
    if (string)
    {
        
        if ([string length] != 0)
        {
            NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([trimmedString length] != 0)
            {
                isStringEmpty = NO;
            }
        }
    }
    
    return isStringEmpty;
}

@end
