//
// CTCBaseValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import <Foundation/Foundation.h>

typedef id (^CTCDefaultValidation) (id value, BOOL *isValid, NSError **error);
typedef id (^CTCPostValidation)(id value);

@interface CTCBaseValidator : NSObject  {
@protected
    BOOL _isValid;
}

@property (nonatomic, assign, readonly) BOOL isValid;
@property (nonatomic, strong) CTCDefaultValidation defaultValidation;
@property (nonatomic, strong) CTCPostValidation postValidation;

- (BOOL)validateValue:(id *)value error:(NSError **)error;

-(id)initWithDefaultValidation:(CTCDefaultValidation)defaultValidation;

-(id)initWithPostValidation:(CTCPostValidation)postValidation;

@end