//
// CTCDoubleTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCDoubleTypeValidator.h"


@implementation CTCDoubleTypeValidator

- (id)init {
    self = [super init];
	
    if (self) {
        self.defaultValidation = ^NSNumber * (id value, BOOL *isValid, NSError **error){
            *isValid = NO;
            if ([value respondsToSelector:@selector(doubleValue)]){
                return @([value doubleValue]);
            }
            return @0.0;
        };
    }

    return self;
}

@end