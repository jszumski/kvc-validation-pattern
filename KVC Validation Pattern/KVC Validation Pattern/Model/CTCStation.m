//
// CTCStation
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//

#import "CTCStation.h"
#import "CTCAddress.h"
#import "CTCArrayTypeValidator.h"
#import "CTCHistoricalPrice.h"
#import "CTCBaseModelValidator.h"


@implementation CTCStation {
    CTCArrayTypeValidator	*_historyValidator;
    CTCBaseModelValidator	*_addressValidator;
    dispatch_once_t			_historyToken;
    dispatch_once_t			_addressToken;
}

- (NSDictionary *)undefinedKeys {
    static NSDictionary *undefinedKeys;
    static dispatch_once_t onceToken;
	
    dispatch_once(&onceToken, ^{
        undefinedKeys = @{@"description": @"stationName"};
    });
	
    return undefinedKeys;
}

- (BOOL)validateHistoricalPrices:(id *)ioValue error:(NSError *__autoreleasing *)outError{
    dispatch_once(&_historyToken, ^{
		// if this happens to be a single object (i.e. a dictionary) then assume it was supposed to be an array of one element
        _historyValidator = [[CTCArrayTypeValidator alloc] initWithDefaultValidation:^NSArray *(id value, BOOL *isValid, NSError **error){
            if ([value isKindOfClass:[NSDictionary class]]){
                *isValid = YES;
                return @[value];
            }
            return nil;
        }];
		
		// take the array we are given and process its contents as CTCHistoricalPrice objects
        _historyValidator.postValidation = ^NSArray *(id value){
            NSMutableArray *histories = [NSMutableArray array];
            for (NSDictionary *dict in value){
                CTCHistoricalPrice *price = [[CTCHistoricalPrice alloc] initWithDictionary:dict];
                [histories addObject:price];
            }
            return histories;
        };
    });

    return [_historyValidator validateValue:ioValue error:outError];
}

- (BOOL)validateAddress:(id *)ioValue error:(NSError *__autoreleasing*)outError{
    dispatch_once(&_addressToken, ^{
        _addressValidator = [[CTCBaseModelValidator alloc] initWithClass:[CTCAddress class]];
    });

    return [_addressValidator validateValue:ioValue error:outError];
}

- (NSString *)description {
	return [[super description] stringByAppendingFormat:@" (name=\"%@\", sellsDiesel=%i, price=%f, address=\"%@\", historical prices=%@)", self.stationName, self.sellsDiesel, self.price, self.address, self.historicalPrices];
}

@end