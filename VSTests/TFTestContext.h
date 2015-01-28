//
//  TFTestContext.h
//  VSTests
//
//  Created by James Campbell on 12/09/2014.
//  Copyright (c) 2014 James Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFTestContext : NSObject

@property (nonatomic, strong) NSString *subjectName;
@property (nonatomic, assign) NSInteger iteration;
@property (nonatomic, assign) NSInteger variation;

@end
