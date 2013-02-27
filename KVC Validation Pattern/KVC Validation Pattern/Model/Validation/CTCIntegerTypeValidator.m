//
// CTCIntegerTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCIntegerTypeValidator.h"


@implementation CTCIntegerTypeValidator

- (id)init {
    self = [super init];
	
    if (self) {
        self.defaultValidation = ^NSNumber * (id value, BOOL *isValid, NSError **error){
            *isValid = YES;
            if ([value respondsToSelector:@selector(integerValue)]){
                return @([value integerValue]);
            }
            return @0;
        };
    }

    return self;
}

@end