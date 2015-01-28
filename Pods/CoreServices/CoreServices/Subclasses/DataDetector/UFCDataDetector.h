//
//  UFCDataDetector.h
//  Common
//
//  Created by James Campbell on 12/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 UFCDataDetector is an abstract subclass of NSRegularExpression which allows you to define your own data detectors. 
 
 See UFCHashtagDataDetector for an implementation of this with hashtags.
 
 @warning You should never instansiate this directly, this should always be subclassed.
 
 @since 1.0
 */
@interface UFCDataDetector : NSRegularExpression

/*!
 Returns a new instance of the detector.
 
 @return An instance of the detector.
 
 @since 1.0
 */
+ (instancetype)detector;

@end
