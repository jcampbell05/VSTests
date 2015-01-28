//
//  CASNull.h
//  CASServices
//
//  Created by James Campbell on 04/07/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASNull : NSObject

/**
 Convenience init method
 
 @return - a new CASNull object
 */
+ (instancetype)null;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (id)objectForKeyedSubscript:(id <NSCopying>)key;

@end
