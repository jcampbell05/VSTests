//
//  CDSDeletionService.m
//  CoreDataServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CDSDeletionService.h"
#import "CDSRetrievalService.h"
#import "CDSServiceManager.h"

@implementation CDSDeletionService

#pragma mark - Single

+ (void) deleteManagedObject:(NSManagedObject *)managedObject
{
    [CDSDeletionService deleteManagedObject:managedObject
                          saveAfterDeletion:YES
                       managedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (void) deleteManagedObject:(NSManagedObject *)managedObject saveAfterDeletion:(BOOL)saveAfterDeletion
{
    [CDSDeletionService deleteManagedObject:managedObject
                          saveAfterDeletion:saveAfterDeletion
                       managedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (void) deleteManagedObject:(NSManagedObject *)managedObject managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [CDSDeletionService deleteManagedObject:managedObject
                          saveAfterDeletion:YES
                       managedObjectContext:managedObjectContext];
}

+ (void) deleteManagedObject:(NSManagedObject *)managedObject
           saveAfterDeletion:(BOOL)saveAfterDeletion
        managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    if (managedObject &&
        managedObjectContext)
    {
        [managedObjectContext deleteObject:managedObject];
        
        if (saveAfterDeletion)
        {
           [CDSServiceManager saveManagedObjectContext:managedObjectContext]; 
        }
    }
}

#pragma mark - Multiple

+ (void) deleteEntriesForEntityClass:(Class)entityClass
                     predicate:(NSPredicate *)predicate
                   saveAfterDeletion:(BOOL)saveAfterDeletion
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSArray *entities = [CDSRetrievalService retrieveEntriesForEntityClass:entityClass
                                                                 predicate:predicate
                                                      managedObjectContext:managedObjectContext];
    
    for (NSManagedObject *entity in entities)
    {
        [CDSDeletionService deleteManagedObject:entity
                              saveAfterDeletion:saveAfterDeletion
                           managedObjectContext:managedObjectContext];
    }
}

+ (void) deleteEntriesForEntityClass:(Class)entityClass
                           predicate:(NSPredicate *)predicate
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [CDSDeletionService deleteEntriesForEntityClass:entityClass
                                          predicate:predicate
                                  saveAfterDeletion:YES
                               managedObjectContext:managedObjectContext];
}

+ (void) deleteEntriesForEntityClass:(Class)entityClass
                     predicate:(NSPredicate *)predicate
{
    [CDSDeletionService deleteEntriesForEntityClass:entityClass
                                          predicate:predicate
                                  saveAfterDeletion:YES
                               managedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (void) deleteEntriesForEntityClass:(Class)entityClass
                     predicate:(NSPredicate *)predicate
                   saveAfterDeletion:(BOOL)saveAfterDeletion
{
    [CDSDeletionService deleteEntriesForEntityClass:entityClass
                                          predicate:predicate
                                  saveAfterDeletion:saveAfterDeletion
                               managedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (void) deleteEntriesForEntityClass:(Class)entityClass
{
    [CDSDeletionService deleteEntriesForEntityClass:entityClass
                                          predicate:nil
                                  saveAfterDeletion:YES
                               managedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (void) deleteEntriesForEntityClass:(Class)entityClass
                   saveAfterDeletion:(BOOL)saveAfterDeletion
{
    [CDSDeletionService deleteEntriesForEntityClass:entityClass
                                          predicate:nil
                                  saveAfterDeletion:saveAfterDeletion
                               managedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (void) deleteEntriesForEntityClass:(Class)entityClass
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [CDSDeletionService deleteEntriesForEntityClass:entityClass
                                          predicate:nil
                                  saveAfterDeletion:YES
                               managedObjectContext:managedObjectContext];
}

+ (void) deleteEntriesForEntityClass:(Class)entityClass
                   saveAfterDeletion:(BOOL)saveAfterDeletion
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    [CDSDeletionService deleteEntriesForEntityClass:entityClass
                                          predicate:nil
                                  saveAfterDeletion:saveAfterDeletion
                               managedObjectContext:managedObjectContext];
}

@end
