//
//  UFCDataDetectorResult.h
//  Common
//
//  Created by James Campbell on 12/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  UFCDataDetector;

/*!
 UFCDataDetectorResult is an object used to represent a result from a UFCDataDetector.
 
 @since 1.0
 */
@interface UFCDataDetectorResult : NSObject

@property(nonatomic, strong, readonly) Class detectorClass;
@property(nonatomic, readonly) NSRange range;

+ (instancetype)resultWithDetector:(UFCDataDetector *)detector andRange:(NSRange)range;

@end
