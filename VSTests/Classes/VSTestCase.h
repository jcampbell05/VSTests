//
//  VSTestCase.h
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSTestContext.h"
#import "VSTestResult.h"

#define VSFail(...) NSAssert(false, __VA_ARGS__)

@class VSTestExpectation;

typedef void(^TFTestDoneBlock)(void);

/**
 *  This class mirrors the new XCTestExpectation API from Xcode 6's XCTest framework
 */
@interface VSTestExpectation : NSObject

/**
 *  Call -fulfill to mark an expectation as having been met. It's an error to call
 *  `-fulfill` on an expectation that has already been fulfilled or when the test case
 *  that vended the expectation has already completed.
 */
-(void)fulfill;

@end

@interface VSTestCase : NSObject

@property (nonatomic, strong, readonly) VSTestContext *context;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSProgress *progress;
@property (nonatomic, strong, readonly) VSTestResult *result;

+ (instancetype)test;

- (NSInteger)maximumIterations;
- (NSInteger)numberOfVariations;
- (void)setUp;
- (void)tearDown;

- (void)runWithNIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (NSArray *)testMethods;

@end

@interface VSTestCase (Async)

/**
*  Creates and returns an expectation associated with the test case.
*
*  @param description This string will be displayed in the test log to help diagnose failures.
*/
- (VSTestExpectation *)expectationWithDescription:(NSString *)description;

/**
 *  A block to be invoked when a call to `-waitForExpectationsWithTimeout:handler:`
 *  times out or has had all associated expectations fulfilled.
 *
 * @param error If the wait timed out or a failure was raised while waiting,
 *              the error's code will specify the type of failure.
 *              Otherwise error will be nil.
 */
typedef void (^XCWaitCompletionHandler)(NSError *error);

/**
 * `-waitForExpectationsWithTimeout:handler:` creates a point of synchronization in the flow of a
 * test. Only one -waitForExpectationsWithTimeout:handler: can be active at any given time, but
 * multiple discrete sequences of { expectations -> wait } can be chained together.
 *
 * `-waitForExpectationsWithTimeout:handler:` runs the run loop while handling events until all expectations
 * are fulfilled or the timeout is reached. Clients should not manipulate the run
 * loop while using this API.
 *
 * @param timeout The amount of time within which all expectations must be fulfilled.
 * @param handlerOrNil If provided, the handler will be invoked both on timeout or fulfillment
 *                     of all expectations. Timeout is always treated as a test failure.
 */
- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout handler:(XCWaitCompletionHandler)handlerOrNil;

@end