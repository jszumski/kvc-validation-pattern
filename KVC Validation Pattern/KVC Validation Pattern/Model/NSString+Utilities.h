//
// NSString(Utilities)
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (Utilities)

+ (NSString *)capitalizeFirstCharacter:(NSString *)string;

+ (NSString *)stripNonNumericCharacters:(NSString *)string;

+ (NSString *)leftPadString:(NSString *)string length:(NSUInteger)length padCharacter:(NSString *)padCharacter;

@end