//
//  CASJSONRequestSerializer.m
//  CASServices
//
//  Created by James Campbell on 27/06/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "CASJSONRequestSerializer.h"
#import "CASSessionManager.h"
#import "CASServiceManager.h"

@implementation CASJSONRequestSerializer

#pragma mark - Request

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    if ( [CASSessionManager sharedInstance].isSessionValid )
    {
        if ([[request.URL absoluteString] rangeOfString:[CASServiceManager sharedInstance].APIHost].location != NSNotFound)
        {
            NSString *authorizationHeader = [NSString stringWithFormat:@"Bearer %@", [CASSessionManager sharedInstance].accessToken];
            
            [self setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
        }
    }
    
    return [super requestBySerializingRequest:[mutableRequest copy] withParameters:parameters error:error];
}

@end
