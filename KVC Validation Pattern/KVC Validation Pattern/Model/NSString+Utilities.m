//
// NSString(Utilities)
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import "NSString+Utilities.h"


@implementation NSString (Utilities)

+ (NSString *)capitalizeFirstCharacter:(NSString *)string {
    NSString *firstCharacter = [[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstCharacter];
    return cappedString;
}

@end