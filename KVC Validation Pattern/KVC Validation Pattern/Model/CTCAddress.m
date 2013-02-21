//
// CTCAddress
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCAddress.h"
#import "CTCStringTypeValidator.h"
#import "NSString+Utilities.h"


@implementation CTCAddress{
    CTCStringTypeValidator *_zipValidator;
    dispatch_once_t _onceToken;
}

- (BOOL)validateZip:(id *)ioValue error:(NSError *__autoreleasing *)outError{
    dispatch_once(&_onceToken, ^{
        _zipValidator = [CTCStringTypeValidator new];
        _zipValidator.postValidation = ^NSString *(id value){
            value = [NSString leftPadString:value length:5 padCharacter:@"0"];
            return value;
        };
    });
    return [_zipValidator validateValue:ioValue error:outError];
}

- (NSString *)description {
	return [[super description] stringByAppendingFormat:@" (street=\"%@\", city=\"%@\", state=\"%@\", zip=\"%@\"", self.street, self.city, self.state, self.zip];
}

@end