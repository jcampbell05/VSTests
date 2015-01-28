//
//  VSTestResult.m
//  VSTests
//
//  Created by James Campbell on 11/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import "VSTestResult.h"

@implementation VSTestResult

- (NSMutableDictionary *)plots
{
    if (!_plots)
    {
        _plots = [[NSMutableDictionary alloc] init];
    }
    
    return _plots;
}

- (void)addPoint:(CGPoint)point forSubject:(NSString *)subject
{
    NSMutableArray *points = self.plots[subject];
    
    if (!points)
    {
        points = [[NSMutableArray alloc] init];
        self.plots[subject] = points;
    }
    
    NSValue *plotValue  = [NSValue valueWithCGPoint: point];
    [points addObject: plotValue];
}

- (void)clear
{
    self.plots = nil;
}

@end
