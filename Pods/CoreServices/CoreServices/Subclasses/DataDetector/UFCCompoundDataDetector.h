//
//  UFCCompoundDataDetector.h
//  Common
//
//  Created by James Campbell on 12/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UFCDataDetector.h"

/*!
 UFCCompoundDataDetector is a concrete implementation of UFCDataDetector for using multiple data detectors at once.
 
 @since 1.0
 */
@interface UFCCompoundDataDetector : UFCDataDetector

/*!
 An array of the detectors used in this compound.
 
 @since 1.0
 */
@property (nonatomic, strong) NSArray * detectors;

/*!
 Initilises the compound data detector with an array of data detectors to use at once.
 
 @param detectors An array of data detectors.
 
 @return Returns an instance of the compound data detector.
 
 @since 1.0
 */
- (instancetype)initWithDetectors:(NSArray *)detectors;

@end
