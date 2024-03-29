//
//  VSTestResult.h
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFTestResultDataPoint;

@interface VSTestResult : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *plots;
@property (nonatomic, strong) NSString *xAxisLabel;
@property (nonatomic, strong) NSString *yAxisLabel;
@property (nonatomic, assign) BOOL resultReady;

- (void)addPoint:(CGPoint)point forSubject:(NSString *)subject;
- (void)clear;

@end
