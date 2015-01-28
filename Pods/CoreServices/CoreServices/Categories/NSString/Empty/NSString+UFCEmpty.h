//
//  NSString+Empty.h
//  Common
//
//  Created by William Boles on 11/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UFCEmpty)

- (BOOL) ufc_isEmpty;
+ (BOOL) ufc_isEmpty:(NSString *)string;

@end
