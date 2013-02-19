//
// CTCHistoricalPrice
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCHistoricalPrice.h"


@implementation CTCHistoricalPrice

- (NSString *)description {
	return [[super description] stringByAppendingFormat:@" (date=%@, price=%f)", self.date, self.price];
}

@end