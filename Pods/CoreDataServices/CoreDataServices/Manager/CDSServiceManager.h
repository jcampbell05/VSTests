//
//  CoreDataServices.h
//  CoreDataServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDSServiceManager : NSObject

/*
 ManagedObjectContext that is used as the default managedObjectContext
 
 If when accessing a core data entity, if no managedobjectcontext is specified this one will be used
 
 @return Managed Object Context
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/*
 Singleton
 
 @return common CDSServiceManager instance
 */
+ (instancetype) sharedInstance;

/*
 Class convenience method for accessing the managedObjectContext that executes on the main thread
 
 This is the managedObjectContext set as managedObjectContext property
 
 @return ManagedObjectContext
 */
+ (NSManagedObjectContext *) managedObjectContext;

/*
 Saves default managedObjectContext
 */
+ (void) saveManagedObjectContext;

/*
 Saves specfic managedObjectContext
 
 @param managedObjectContext to be saved
 */
+ (void) saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
