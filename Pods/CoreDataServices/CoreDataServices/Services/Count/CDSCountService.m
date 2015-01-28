//
//  CDSCountService.m
//  CoreDataServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CDSCountService.h"
#import <CoreServices/NSString+UFCEmpty.h>
#import "CDSServiceManager.h"

@implementation CDSCountService

#pragma mark - Count

+ (NSUInteger) retrieveEntriesCountForEntityClass:(Class)entityClass
                                        predicate:(NSPredicate *)predicate
                             managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSUInteger count = 0;
    
    NSString *entityName = NSStringFromClass(entityClass);
    
    if (![NSString ufc_isEmpty:entityName])
    {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        if (predicate)
        {
            [request setPredicate:predicate];
        }
        
        NSError *error = nil;
        
        count = [managedObjectContext countForFetchRequest:request
                                                     error:&error];
        
        if (error)
        {
            NSLog(@"Error attempting to retrieve entries count from table %@ with pred %@: %@", entityName, predicate, [error userInfo]);
        }
        
    }
    
    return count;
    
}

+ (NSUInteger) retrieveEntriesCountForEntityClass:(Class)entityClass
                                        predicate:(NSPredicate *)predicate
{
    return [CDSCountService retrieveEntriesCountForEntityClass:entityClass
                                                     predicate:predicate
                                          managedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (NSUInteger) retrieveEntriesCountForEntityClass:(Class)entityClass
                             managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    return [CDSCountService retrieveEntriesCountForEntityClass:entityClass
                                                     predicate:nil
                                          managedObjectContext:managedObjectContext];
}

+ (NSUInteger) retrieveEntriesCountForEntityClass:(Class)entityClass
{
    return [CDSCountService retrieveEntriesCountForEntityClass:entityClass
                                                     predicate:nil
                                          managedObjectContext:[CDSServiceManager managedObjectContext]];
}

@end
