//
//  TFTest.m
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <objc/runtime.h>

#import "TFTest.h"

@interface TFTest ()

@end

@implementation TFTest

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

- (TFTestResult *)runWithNIterations:(NSInteger)iterations;
{
    [self.result clear];
    self.progress.completedUnitCount = 0.0f;
    
    NSArray *testMethods = [self testMethods];
    self.progress.totalUnitCount = testMethods.count * iterations;
    
    [testMethods enumerateObjectsUsingBlock:^(NSString *methodName, NSUInteger idx, BOOL *stop)
    {
        TFTestContext *testContext = [[TFTestContext alloc] init];
        testContext.subjectName = [methodName stringByReplacingOccurrencesOfString:@"test" withString:@""];
        SEL selector = NSSelectorFromString(methodName);

        for (int i = 1; i <= iterations; i ++)
        {
            testContext.iteration = i;
            
            [self setUp: testContext];
            [self performSelector:selector];
            [self tearDown: testContext];
            
            self.progress.completedUnitCount ++;
        }
    }];
    
    return self.result;
}

- (void)setUp:(TFTestContext *)context
{
    
}

- (void)tearDown:(TFTestContext *)context
{
    
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
