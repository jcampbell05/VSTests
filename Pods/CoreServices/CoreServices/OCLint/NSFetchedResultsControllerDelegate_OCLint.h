//
//  NSFetchedResultsControllerDelegate_OCLint.h
//  CoreServices
//
//  Created by James Campbell on 16/05/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "OCLint-Annotations.h"

@protocol NSFetchedResultsControllerDelegate 

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller OCLINT_SUPPRESS_UNUSED_METHOD_PARAMETER;

@end
