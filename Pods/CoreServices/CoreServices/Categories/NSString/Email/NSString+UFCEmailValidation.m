//
//  NSString+UFCEmailValidation.h
//  Common
//
//  Created by William Boles on 14/04/14.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "NSString+UFCEmailValidation.h"
#import "NSString+UFCEmpty.h"

@implementation NSString (UFCEmailValidation)

#pragma mark - Validation

- (BOOL) ufc_isValidEmailAddress
{
    return [NSString ufc_isValidEmailAddress:self
                             validationLevel:UFCEmailAddressValidationLevelStrict];
}

- (BOOL) ufc_isValidEmailAddressWithValidationLevel:(UFCEmailAddressValidationLevel)validationLevel
{
    return [NSString ufc_isValidEmailAddress:self
                             validationLevel:validationLevel];
}

+ (BOOL) ufc_isValidEmailAddress:(NSString *)string
{
    return [NSString ufc_isValidEmailAddress:string
                             validationLevel:UFCEmailAddressValidationLevelStrict];
}

+ (BOOL) ufc_isValidEmailAddress:(NSString *)string
                 validationLevel:(UFCEmailAddressValidationLevel)validationLevel
{
    NSString *emailRegex = nil;
    
    switch (validationLevel)
    {
        case UFCEmailAddressValidationLevelLax:
        {
            emailRegex = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
            
            break;
        }
        case UFCEmailAddressValidationLevelStrict:
        default:
        {
            
            emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            
            break;
        }
    }
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:string];
}

@end
