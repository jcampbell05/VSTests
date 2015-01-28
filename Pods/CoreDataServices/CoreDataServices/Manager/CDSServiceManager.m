//
//  CoreDataServices.m
//  CoreDataServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CDSServiceManager.h"

@implementation CDSServiceManager

#pragma mark - Singleton

+ (instancetype) sharedInstance
{
    static CDSServiceManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[CDSServiceManager alloc] init];
                  });
    
    return sharedInstance;
}
    
#pragma mark - Managed Object Context

+ (void) saveManagedObjectContext
{
    [CDSServiceManager saveManagedObjectContext:[CDSServiceManager managedObjectContext]];
}

+ (void) saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSError *error = nil;
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Couldn't save context: %@", [error userInfo]);
    }
    else
    {
        [managedObjectContext processPendingChanges];
    }
}

+ (NSManagedObjectContext *) managedObjectContext
{
    return [CDSServiceManager sharedInstance].managedObjectContext;
}

@end
