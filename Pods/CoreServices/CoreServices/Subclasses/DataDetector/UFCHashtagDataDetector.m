//
//  UFCHashtagDataDetector.m
//  Common
//
//  Created by James Campbell on 12/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UFCHashtagDataDetector.h"

@implementation UFCHashtagDataDetector

- (instancetype)init {
    
    if ( self = [super initWithPattern:@"#[\\w]+" options:0 error:NULL] ) {
        
        
    }
    
    return self;
}

@end
