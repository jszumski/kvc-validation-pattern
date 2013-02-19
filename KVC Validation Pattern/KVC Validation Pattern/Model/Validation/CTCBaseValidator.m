//
// CTCBaseValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCBaseValidator.h"


@implementation CTCBaseValidator {

}
- (BOOL)validateValue:(id *)value error:(NSError **)error {
    if (!self.isValid){
        if (self.defaultValidation) {
            *value = self.defaultValidation(*value, &_isValid, error);
        }
    }

    if (self.isValid && self.postValidation){
        *value = self.postValidation(*value);
    }

    return self.isValid;
}

- (id)initWithDefaultValidation:(CTCDefaultValidation)defaultValidation {
    self = [self init];
    if (self){
        _defaultValidation = defaultValidation;
    }

    return self;
}

- (id)initWithPostValidation:(CTCPostValidation)postValidation {
    self = [self init];
    if (self){
        _postValidation = postValidation;
    }

    return self;
}


@end