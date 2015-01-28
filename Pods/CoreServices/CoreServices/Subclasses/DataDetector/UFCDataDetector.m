//
//  UFCDataDetector.m
//  Common
//
//  Created by James Campbell on 12/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UFCDataDetector.h"
#import "UFCDataDetectorResult.h"

@implementation UFCDataDetector

+ (instancetype)detector {
    
    UFCDataDetector * newDetector = [[self alloc] init];
    
    return newDetector;
}

- (NSArray *)matchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range {
    
    NSArray * matches = [super matchesInString:string options:options range:range];
    
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult * match in matches) {
        
        UFCDataDetectorResult * result = [UFCDataDetectorResult resultWithDetector:self andRange:match.range];
        
        [results addObject: result];
    }
    
    return [results copy];
}

@end
