//
// CTCBooleanTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCBooleanTypeValidator.h"


@implementation CTCBooleanTypeValidator {

}

- (id)init {
    self = [super init];
    if (self) {
        self.defaultValidation = ^NSNumber * (id value, BOOL *isValid, NSError **error){
            *isValid = YES;
            NSString *stringValue = @"NO";
            if ([value isKindOfClass:[NSString class]]){
                stringValue = value;
            } else if ([value respondsToSelector:@selector(stringValue)]){
                stringValue = [value stringValue];
            }
            if ([stringValue caseInsensitiveCompare:@"true"] == NSOrderedSame ||
                    [stringValue caseInsensitiveCompare:@"yes"] == NSOrderedSame ||
                    [stringValue caseInsensitiveCompare:@"y"] == NSOrderedSame ||
                    [stringValue caseInsensitiveCompare:@"1"] == NSOrderedSame){
                return @YES;
            }
            return @NO;
        };
    }

    return self;
}

@end