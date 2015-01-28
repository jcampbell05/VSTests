//
//  UFCCompoundDataDetector.m
//  Common
//
//  Created by James Campbell on 12/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UFCCompoundDataDetector.h"

@implementation UFCCompoundDataDetector

- (instancetype)initWithDetectors:(NSArray *)detectors {
    
    if ( self = [super init]) {
        
        self.detectors = detectors;
    }
    
    return self;
}

- (NSArray *)matchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range {

    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for (UFCDataDetector * detector in self.detectors) {
        
        
        
        NSArray * matches = [detector matchesInString:string options:options range:range];
        
        [results addObjectsFromArray: matches];
        
    }
    
    return [results copy];
}

@end
