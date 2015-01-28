//
//  VSTestCase.h
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFTestContext.h"
#import "TFTestResult.h"

@import XCTest;

typedef void(^TFTestDoneBlock)(void);

@interface VSTestCase : XCTestCase

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSProgress *progress;
@property (nonatomic, strong, readonly) TFTestResult *result;

+ (instancetype)test;

- (NSInteger)maximumIterations;
- (NSInteger)numberOfVariations;
- (void)setUp:(TFTestContext *)context;
- (void)tearDown:(TFTestContext *)context;

- (void)runWithNIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (NSArray *)testMethods;

@end
