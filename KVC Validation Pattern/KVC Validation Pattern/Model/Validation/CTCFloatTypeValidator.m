//
// CTCFloatTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCFloatTypeValidator.h"


@implementation CTCFloatTypeValidator {

}
- (id)init {
    self = [super init];
    if (self) {
        self.defaultValidation = ^NSNumber * (id value, BOOL *isValid, NSError **error){
            *isValid = YES;
            if ([value respondsToSelector:@selector(floatValue)]){
                return @([value floatValue]);
            }
            return @0.0f;
        };
    }

    return self;
}

@end