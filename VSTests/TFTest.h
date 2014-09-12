//
//  TFTest.h
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFTestContext.h"
#import "TFTestResult.h"

@interface TFTest : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSProgress *progress;
@property (nonatomic, strong, readonly) TFTestResult *result;

+ (instancetype)test;


- (void)setUp:(TFTestContext *)context;
- (void)tearDown:(TFTestContext *)context;

- (TFTestResult *)runWithNIterations:(NSInteger)iterations;
- (NSArray *)testMethods;

@end
