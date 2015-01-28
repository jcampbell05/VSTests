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

- (void)setUp
{
    [super setUp];
    
    self.stopwatch = [MMStopwatchItemARC itemWithName:self.context.subjectName];
}

- (void)tearDown
{
    [super tearDown];

    NSAssert(self.stopwatch, @"No stopwatch created, please check all of your tests call [super setUp].");
    [self.stopwatch stop];
    
    NSLog(@"Completed Test: %@", self.stopwatch.description);
    [self.timeResultSource addPoint:CGPointMake(self.context.iteration, self.stopwatch.runtimeMills / 1000)
                         forSubject:self.context.subjectName];
}

@end
