//
// CTCDateTypeValidator
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCDateTypeValidator.h"

@implementation CTCDateTypeValidator

- (id)init {
    self = [super init];
	
    if (self) {
        self.defaultValidation = ^NSDate *(id value, BOOL *isValid, NSError **error){
            if ([value isKindOfClass:[NSNumber class]]){
                *isValid = YES;
                return [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
            }
            static NSDateFormatter *dateFormatter;
            static dispatch_once_t onceToken;
            static dispatch_queue_t dateQueue;
            dispatch_once(&onceToken, ^{
                dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
                dateQueue = dispatch_queue_create("com.captech.datequeue", NULL);
            });
            NSString *stringDate;
            if ([value isKindOfClass:[NSString class]]){
                stringDate = value;
            } else if ([value respondsToSelector:@selector(stringValue)]){
                stringDate = [value stringValue];
            }
            if (stringDate){
                *isValid = YES;
                __block NSDate *date;
                dispatch_sync(dateQueue, ^{
                    date = [dateFormatter dateFromString:stringDate];
                });
                return date;
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