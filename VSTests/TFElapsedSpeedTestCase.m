//
//  TFElaspedSpeedTest.m
//  VSTests
//
//  Created by James Campbell on 12/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import "TFElapsedSpeedTestCase.h"

@interface TFElapsedSpeedTestCase ()

@property (nonatomic, strong) TFTestResult *timeResultSource;
@property (nonatomic, assign) clock_t startTime;

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
    
    self.startTime = clock();
}

- (void)tearDown:(TFTestContext *)context
{
    [super tearDown:context];
    
    double executionTime = (double)(clock()-self.startTime) / CLOCKS_PER_SEC;
    [self.timeResultSource addPoint:CGPointMake(context.iteration, executionTime)
                         forSubject:context.subjectName];
}

@end
