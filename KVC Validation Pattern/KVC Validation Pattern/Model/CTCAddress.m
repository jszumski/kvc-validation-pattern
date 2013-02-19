//
// CTCAddress
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "CTCAddress.h"


@implementation CTCAddress

- (NSString *)description {
	return [[super description] stringByAppendingFormat:@" (street=\"%@\", city=\"%@\", state=\"%@\", zip=\"%@\"", self.street, self.city, self.state, self.zip];
}

@end