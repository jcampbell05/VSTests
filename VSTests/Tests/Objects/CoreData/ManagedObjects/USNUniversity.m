//
//  USNUniversity.m
//  Unii
//
//  Created by William Boles on 04/08/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "USNUniversity.h"
#import "USNUser.h"


@implementation USNUniversity

@dynamic name;
@dynamic universityID;
@dynamic users;

#pragma mark - Accessor

+ (instancetype)fetchUniversityWithID:(NSNumber *)universityID
                 managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"universityID==%@", universityID];
    
    return [CDSRetrievalService retrieveFirstEntryForEntityClass:[USNUniversity class]
                                                       predicate:predicate
                                            managedObjectContext:managedObjectContext];
}

+ (instancetype)fetchUniversityWithID:(NSNumber *)universityID
{
    return [self fetchUniversityWithID:universityID
                  managedObjectContext:[CDSServiceManager managedObjectContext]];
}

@end
