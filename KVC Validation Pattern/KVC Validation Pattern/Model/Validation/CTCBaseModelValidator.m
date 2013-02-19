//
// CTCBaseModelValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 ${ORGANIZATION}.  All rights reserved.
//


#import "CTCBaseModelValidator.h"
#import "CTCBaseModel.h"


@implementation CTCBaseModelValidator {

}
- (id)initWithClass:(Class)baseModelClass {
    self = [super init];
    if (self){
        __weak Class blockModelClass = baseModelClass;
        self.postValidation = ^CTCBaseModel *(id value){
            return [[blockModelClass alloc] initWithDictionary:value];
        };
    }
    return self;
}
- (id)initWithDefaultValidation:(CTCDefaultValidation)defaultValidation {
    self = [self init];
    if (self) {
        self.defaultValidation = defaultValidation;
    }

    return self;
}

- (id)init {
    return [self initWithClass:[CTCBaseModel class]];
}

- (BOOL)validateValue:(id *)value error:(NSError **)error {
    _isValid = [*value isKindOfClass:[NSDictionary class]];
    return [super validateValue:value error:error];
}

@end