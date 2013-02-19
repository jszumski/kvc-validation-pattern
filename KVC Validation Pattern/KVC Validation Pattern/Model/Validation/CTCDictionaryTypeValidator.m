//
// CTCDictionaryTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCDictionaryTypeValidator.h"


@implementation CTCDictionaryTypeValidator {

}
- (BOOL)validateValue:(id *)value error:(NSError **)error {
    _isValid = [*value isKindOfClass:[NSDictionary class]];
    return [super validateValue:value error:error];
}

- (id)init {
    self = [super init];
    if (self) {
        self.defaultValidation = ^NSDictionary * (id value, BOOL *isValid, NSError **error){
            *isValid = NO;
            return nil;
        };
    }

    return self;
}

@end