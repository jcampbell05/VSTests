//
//  TFTest.m
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//
#import "VSTestCase.h"

#import <libkern/OSAtomic.h>
#import <objc/runtime.h>

static NSTimeInterval const kRunLoopSamplingInterval = 0.01;

@interface VSTestExpectation()

@property(strong) NSString* descritionString;
@property(weak) VSTestCase* associatedTestCase;
@property(readonly) BOOL fulfilled;

@end

@interface VSTestCase ()
{
    NSMutableArray* _expectations;
    OSSpinLock _expectationsLock;
    int32_t _unfulfilledExpectationsCount;
}

@property (nonatomic, strong, readwrite) VSTestContext *context;

- (void)runTestMethods:(NSArray *)methods withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (void)runTestMethod:(NSString *)method withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (void)runVariations:(NSInteger)totalVariation withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (void)runIterations:(NSInteger)totalIterations completion:(TFTestDoneBlock)completion;
- (void)decrementUnfulfilledExpectationsCount;

@end

@implementation VSTestExpectation

- (void)fulfill
{
    if(!self.associatedTestCase)
    {
        [NSException raise:NSInternalInconsistencyException format:@"The test case associated with this XCTestExpectation %@ has already finished!", self];
    }
    if (_fulfilled)
    {
        [NSException raise:NSInternalInconsistencyException format:@"The XCTestExpectation %@ has already been fulfilled!", self];
    }
    _fulfilled = YES;
    [self.associatedTestCase decrementUnfulfilledExpectationsCount];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"\"%@\"", _descritionString];
}

@end

@implementation VSTestCase

@synthesize progress = _progress;

+ (instancetype)test
{
    return [self new];
}

- (NSString *)title
{
    return NSStringFromClass(self.class);
}

- (NSProgress *)progress
{
    if (!_progress)
    {
        _progress = [[NSProgress alloc] init];
    }
    
    return _progress;
}

- (void)runWithNIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion
{
    [self.result clear];
    
    CGFloat actualIterations = MIN(iterations, self.maximumIterations);
    self.progress.completedUnitCount = 0.0f;
    
    NSArray *testMethods = [self testMethods];
    self.progress.totalUnitCount = testMethods.count * iterations;
    
    [self runTestMethods:testMethods withIterations:iterations completion:^{
       
        completion();
    }];
}

- (void)runTestMethods:(NSArray *)methods withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion
{
    NSMutableArray *mutableMethods = [methods mutableCopy];
    NSString *currentMethodName = [mutableMethods lastObject];
    [mutableMethods removeLastObject];
    
    [self runTestMethod:currentMethodName withIterations:iterations completion:^{
       
        if (mutableMethods.count > 0)
        {
            [self runTestMethods:mutableMethods withIterations:iterations completion:completion];
        }
        else if(completion)
        {
            completion();
        }
    }];
}

- (void)runTestMethod:(NSString *)method withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion
{
    self.context = [[VSTestContext alloc] init];
    self.context.subjectName = [method stringByReplacingOccurrencesOfString:@"test" withString:@""];
    self.context.variation = 0;
    
    [self runVariations:self.numberOfVariations withIterations:iterations completion:^
    {
        completion();
    }];
}

- (void)runVariations:(NSInteger)totalVariation withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion
{
    self.context.iteration = 0;
    
    [self runIterations:iterations completion:^
    {
        self.context.variation ++;
        
        if (self.context.variation > totalVariation)
        {
            [self runVariations:totalVariation
                 withIterations:iterations
                     completion:completion];
            return;
        }
        else if(completion)
        {
            completion();
        }
    }];
}

- (void)runIterations:(NSInteger)iterationsLeft completion:(TFTestDoneBlock)completion
{
    if (iterationsLeft == 0)
    {
        if (completion)
        {
            completion();
        }
        
        return;
    }
    
    NSString *methodName = [NSString stringWithFormat:@"test%@", self.context.subjectName];
    SEL selector = NSSelectorFromString(methodName);
    
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    [invocation setSelector:selector];
    [invocation setTarget:self];
    
    [self setUp];
    [invocation invoke];
    [self tearDown];
    
    self.progress.completedUnitCount ++;
    NSInteger newIterationsLeft = iterationsLeft - 1;
    self.context.iteration ++;
    
    [self runIterations:newIterationsLeft
             completion:completion];
}

- (NSInteger)maximumIterations
{
    return CGFLOAT_MAX;
}

- (NSInteger)numberOfVariations
{
    return 1;
}

- (void)setUp
{
    _expectations = [NSMutableArray new];
    _unfulfilledExpectationsCount = 0;
}

- (void)tearDown
{
    self.result.resultReady = YES;
    
    if (!OSAtomicCompareAndSwap32(0, 0, &_unfulfilledExpectationsCount)) // if unfulfilledExpectationsCount != 0
    {
        OSSpinLockLock(&_expectationsLock);
        [_expectations filterUsingPredicate:[NSPredicate predicateWithFormat:@"fulfilled == NO"]];

        VSFail(@"Failed due to unwaited expectations: %@.", [_expectations componentsJoinedByString:@", "]);
        [_expectations removeAllObjects];
        OSSpinLockUnlock(&_expectationsLock);
    }
}

- (NSArray *)testMethods
{
    unsigned int methodCount;
    Method *methods = class_copyMethodList(self.class, &methodCount);
    NSMutableArray *testMethods = [[NSMutableArray alloc] init];
    
    for (unsigned int i = 0; i < methodCount; i ++)
    {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        
        if ([name hasPrefix:@"test"])
        {
            [testMethods addObject:name];
        }
    }
    
    free(methods);
    
    return [testMethods copy];
}

- (VSTestExpectation *)expectationWithDescription:(NSString *)description
{
    VSTestExpectation* expectation = [VSTestExpectation new];
    expectation.associatedTestCase = self;
    expectation.descritionString = description;
    
    OSSpinLockLock(&_expectationsLock);
    {
        [_expectations addObject:expectation];
        OSAtomicIncrement32(&_unfulfilledExpectationsCount);
    }
    OSSpinLockUnlock(&_expectationsLock);
    
    return expectation;
}

- (void)decrementUnfulfilledExpectationsCount
{
    OSAtomicDecrement32(&_unfulfilledExpectationsCount);
}

- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout handler:(XCWaitCompletionHandler)handlerOrNil
{
    NSDate* timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    
    while ([timeoutDate timeIntervalSinceNow]>0)
    {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, kRunLoopSamplingInterval, YES);
        if (OSAtomicCompareAndSwap32(0, 0, &_unfulfilledExpectationsCount)) break; // if all expectations fulfilled, break
    }
    
    NSError* error = nil;
    
    if (!OSAtomicCompareAndSwap32(0, 0, &_unfulfilledExpectationsCount)) // if unfulfilledExpectationsCount != 0
    {
        error = [NSError errorWithDomain:@"com.apple.XCTestErrorDomain" code:0 userInfo:nil];
    }
    
    if (handlerOrNil)
    {
        handlerOrNil(error);
    }
    
    if (error)
    {
        OSSpinLockLock(&_expectationsLock);
        [_expectations filterUsingPredicate:[NSPredicate predicateWithFormat:@"fulfilled == NO"]];
        NSString* expectationsList = [_expectations componentsJoinedByString:@", "];
        [_expectations removeAllObjects];
        OSAtomicCompareAndSwap32(_unfulfilledExpectationsCount, 0, &_unfulfilledExpectationsCount); // reset to 0
        OSSpinLockUnlock(&_expectationsLock);
        
        VSFail(@"Asynchronous wait failed: Exceeded timeout of %g seconds, with unfulfilled expectations: %@.",
                timeout, expectationsList);
        
    }
}

@end
