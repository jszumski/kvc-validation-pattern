//
// CTCNumberTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCNumberTypeValidator.h"


@implementation CTCNumberTypeValidator

- (id)init {
    self = [super init];
	
    if (self) {
        self.defaultValidation = ^NSNumber * (id value, BOOL *isValid, NSError **error){
            *isValid = YES;
            // Since we don't know what type of number we are looking for, we will use NSDecimalNumber
            return [NSDecimalNumber decimalNumberWithString:value];
        };
    }

    return self;
}

- (BOOL)validateValue:(id *)value error:(NSError **)error {
    _isValid = [*value isKindOfClass:[NSNumber class]];
    return [super validateValue:value error:error];
}

@end