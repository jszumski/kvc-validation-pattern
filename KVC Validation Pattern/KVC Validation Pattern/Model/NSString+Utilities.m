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

+ (NSString *)stripNonNumericCharacters:(NSString *)string {
    NSMutableString *res = [[NSMutableString alloc] init];

    for(int i = 0; i < [string length]; i++) {
        char next = (char) [string characterAtIndex:(NSUInteger) i];

        if((next >= '0' && next <= '9') || next == '.') {
            [res appendFormat:@"%c", next];
        }
    }

    return res;

}

+ (NSString *)leftPadString:(NSString *)string length:(NSUInteger)length padCharacter:(NSString *)padCharacter {
    NSUInteger padding = length - [string length];
    if (padding > 0){
        NSString *pad = [[NSString string] stringByPaddingToLength:padding withString:padCharacter startingAtIndex:0];
        return [pad stringByAppendingString:string];
    }
    return string;
}

@end