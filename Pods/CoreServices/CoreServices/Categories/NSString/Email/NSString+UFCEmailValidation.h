//
//  NSString+UFCEmailValidation.h
//  Common
//
//  Created by William Boles on 14/04/14.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UFCEmailAddressValidationLevel)
{
    UFCEmailAddressValidationLevelStrict = 0,
    UFCEmailAddressValidationLevelLax = 1,
};

@interface NSString (UFCEmailValidation)

- (BOOL) ufc_isValidEmailAddress;
- (BOOL) ufc_isValidEmailAddressWithValidationLevel:(UFCEmailAddressValidationLevel)validationLevel;

+ (BOOL) ufc_isValidEmailAddress:(NSString *)string;
+ (BOOL) ufc_isValidEmailAddress:(NSString *)string
                 validationLevel:(UFCEmailAddressValidationLevel)validationLevel;

@end
