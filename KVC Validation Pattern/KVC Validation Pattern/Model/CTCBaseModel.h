//
// CTCBaseModel
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CTCBaseModel : NSObject

@property (nonatomic, strong, readonly) NSString *dictionaryKey;
@property (nonatomic, readonly, strong) NSDictionary *undefinedKeys;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)calculateClassName;

@end