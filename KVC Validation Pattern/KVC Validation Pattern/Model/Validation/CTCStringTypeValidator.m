//
// CTCStringTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCStringTypeValidator.h"


@implementation CTCStringTypeValidator

- (id)init {
    self = [super init];
	
    if (self) {
        self.defaultValidation = ^NSString *(id value, BOOL *isValid, NSError **error){
            if ([value respondsToSelector:@selector(stringValue)]){
                *isValid = YES;
                return [value stringValue];
            } else {
                *isValid = NO;
                return nil;
            }
        };
    }

    return self;
}

- (BOOL)validateValue:(id *)value error:(NSError **)error {
    _isValid = [*value isKindOfClass:[NSString class]];
    return [super validateValue:value error:error];
}

@end