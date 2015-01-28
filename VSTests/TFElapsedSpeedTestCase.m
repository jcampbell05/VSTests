//
//  TFElaspedSpeedTest.m
//  VSTests
//
//  Created by James Campbell on 12/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import "TFElapsedSpeedTestCase.h"
#import "MMStopwatchARC.h"

@interface TFElapsedSpeedTestCase ()

@property (nonatomic, strong) TFTestResult *timeResultSource;
@property (nonatomic, strong) MMStopwatchItemARC *stopwatch;

@end

@implementation TFElapsedSpeedTestCase

- (instancetype)init
{
    self = [super init];
    if (self)
	{
        self.timeResultSource = [[TFTestResult alloc] init];
        self.timeResultSource.xAxisLabel = @"Iterations";
        self.timeResultSource.yAxisLabel = @"Time (In Seconds)";
    }
    return self;
}

- (TFTestResult *)result
{
    return self.timeResultSource;
}

- (void)setUp:(TFTestContext *)context
{
    [super setUp:context];
    
    self.stopwatch = [MMStopwatchItemARC itemWithName:context.subjectName];
}

- (void)tearDown:(TFTestContext *)context
{
    [super tearDown:context];
    
    NSAssert(self.stopwatch, @"No stopwatch created, please check all of your tests call [super setUp: context].");
    [self.stopwatch stop];
    
    NSLog(@"Completed Test: %@", self.stopwatch.description);
    [self.timeResultSource addPoint:CGPointMake(context.iteration, self.stopwatch.runtimeMills / 1000)
                         forSubject:context.subjectName];
}

@end
