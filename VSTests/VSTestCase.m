//
//  TFTest.m
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <objc/runtime.h>

#import "VSTestCase.h"

@interface VSTestCase ()

@property (nonatomic, strong) TFTestContext *currentTestContext;

- (void)runTestMethods:(NSArray *)methods withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (void)runTestMethod:(NSString *)method withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (void)runVariations:(NSInteger)totalVariation withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion;
- (void)runIterations:(NSInteger)totalIterations completion:(TFTestDoneBlock)completion;

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
    self.currentTestContext = [[TFTestContext alloc] init];
    self.currentTestContext.subjectName = [method stringByReplacingOccurrencesOfString:@"test" withString:@""];
    self.currentTestContext.variation = 0;
    
    [self runVariations:self.numberOfVariations withIterations:iterations completion:^
    {
        completion();
    }];
}

- (void)runVariations:(NSInteger)totalVariation withIterations:(NSInteger)iterations completion:(TFTestDoneBlock)completion
{
    self.currentTestContext.iteration = 0;
    
    [self runIterations:iterations completion:^
    {
        self.currentTestContext.variation ++;
        
        if (self.currentTestContext.variation > totalVariation)
        {
            [self runVariations:totalVariation withIterations:iterations completion:completion];
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
    
    void (^doneBlock)() = ^
    {
        [self tearDown: self.currentTestContext];
        self.progress.completedUnitCount ++;
        
        NSInteger newIterationsLeft = iterationsLeft - 1;
        self.currentTestContext.iteration ++;
        
        [self runIterations:newIterationsLeft completion:completion];
    };
    
    doneBlock = [doneBlock copy];
    
    NSString *methodName = [NSString stringWithFormat:@"test%@", self.currentTestContext.subjectName];
    SEL selector = NSSelectorFromString(methodName);
    
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    [invocation setSelector:selector];
    [invocation setTarget:self];
    [invocation setArgument:&doneBlock atIndex:2];
    
    [self setUp: self.currentTestContext];
    [invocation invoke];
}

- (NSInteger)maximumIterations
{
    return CGFLOAT_MAX;
}

- (NSInteger)numberOfVariations
{
    return 1;
}

- (void)setUp:(TFTestContext *)context
{
    
}

- (void)tearDown:(TFTestContext *)context
{
    self.result.resultReady = YES;
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

@end
