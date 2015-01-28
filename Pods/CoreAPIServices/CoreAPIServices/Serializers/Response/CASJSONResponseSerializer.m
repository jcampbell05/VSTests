//
//  CASJSONResponseSerializer.m
//  CASServices
//
//  Created by James Campbell on 19/06/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CASJSONResponseSerializer.h"
#import "CASNull.h"

@interface CASJSONResponseSerializer ()

- (void)checkAndConstructError:(NSDictionary *)responseData error:(NSError *__autoreleasing *)error;
- (NSString *)processErrorsResponseData:(NSDictionary *)errorsDataDictionary;
- (NSDictionary *)removeNullValues:(NSDictionary *)dictionary;

@end

@implementation CASJSONResponseSerializer

#pragma mark - ResponseObjectForResponse

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *responseData = [super responseObjectForResponse:response data:data error:error];
    
    [self checkAndConstructError:responseData error:error];
    
    return [self removeNullValues: responseData];
}

#pragma mark - CheckAndConstructError

- (void)checkAndConstructError:(NSDictionary *)responseData
                         error:(NSError *__autoreleasing *)error
{
    __block NSString *errorMessage = nil;
    
    if (responseData[@"error_description"])
    {
        errorMessage = responseData[@"error_description"];
    }
    
    if (responseData[@"errors"])
    {
        errorMessage = [self processErrorsResponseData:responseData[@"errors"]];
    }
    
    if (errorMessage)
    {
        *error = [[NSError alloc] initWithDomain:@"com.unii.apierror" code:1 userInfo:@{ NSLocalizedDescriptionKey: errorMessage}];
    }
}

#pragma mark - ProcessErrorsResponseData

- (NSString *)processErrorsResponseData:(NSDictionary *)errorsDataDictionary
{
    __block NSString *errorMessage = @"Unable to process your request as";
    
    [errorsDataDictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSArray class]])
         {
             NSArray *value = ((NSArray*)obj);
             
             [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
              {
                  errorMessage = [NSString stringWithFormat:@"%@ %@ %@", errorMessage, key, obj];
              }];
         }
     }];
    
    return errorMessage;
}

#pragma mark - RemoveNullValues

- (NSDictionary *)removeNullValues:(NSDictionary *)dictionary {
    
    NSMutableDictionary *mutableDict = [dictionary mutableCopy];
    
    [mutableDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ( obj == [NSNull null] )
        {
            
            mutableDict[key] = [CASNull null];
            
        } else if ( [obj isKindOfClass:[NSDictionary class]] ) {
            
            mutableDict[key] = [self removeNullValues: obj];
        } else if ( [obj isKindOfClass:[NSArray class]] ) {
            
            NSMutableArray *newArray = [obj mutableCopy];
            
            [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                if ( obj == [NSNull null] ) {
                    
                    [newArray removeObjectAtIndex:idx];
                    
                } else if ( [obj isKindOfClass:[NSDictionary class]] )
                {
                    
                    newArray[idx] = [self removeNullValues: obj];
                }
                
            }];
            
            mutableDict[key] = newArray;
        }
    }];
    
    return [mutableDict copy];
}

@end
