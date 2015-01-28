//
//  UFCDataDetectorResult.m
//  Common
//
//  Created by James Campbell on 12/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UFCDataDetectorResult.h"
#import "UFCDataDetector.h"

@interface UFCDataDetectorResult ()

@property(nonatomic, strong, readwrite) Class detectorClass;
@property(nonatomic, readwrite) NSRange range;

@end

@implementation UFCDataDetectorResult

+ (instancetype)resultWithDetector:(UFCDataDetector *)detector andRange:(NSRange)range {
    
    UFCDataDetectorResult * result = [[UFCDataDetectorResult alloc] init];
    result.detectorClass = [detector class];
    result.range = range;
    
    return result;
}

@end
