//
// CTCDateTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCDateTypeValidator.h"


@implementation CTCDateTypeValidator {

}
- (id)init {
    self = [super init];
    if (self) {
        self.defaultValidation = ^NSDate *(id value, BOOL *isValid, NSError **error){
            if ([value respondsToSelector:@selector(integerValue)]){
                *isValid = YES;
                return [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
            }
            *isValid = NO;
            return nil;
        };
    }

    return self;
}

- (BOOL)validateValue:(id *)value error:(NSError **)error {
    _isValid = [*value isKindOfClass:[NSDate class]];
    return [super validateValue:value error:error];
}

@end