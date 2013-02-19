#import "CTCStringTypeValidator.h"
#import "CTCBooleanTypeValidator.h"
#import "CTCIntegerTypeValidator.h"
#import "CTCFloatTypeValidator.h"
#import "CTCArrayTypeValidator.h"
#import "CTCDictionaryTypeValidator.h"
#import "CTCUnsignedIntegerTypeValidator.h"
#import "CTCDoubleTypeValidator.h"
#import "CTCDateTypeValidator.h"

BOOL validateStringProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCStringTypeValidator *validator = [CTCStringTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateBoolProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCBooleanTypeValidator *validator = [CTCBooleanTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateNumberProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCNumberTypeValidator *validator = [CTCNumberTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateIntegerProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCIntegerTypeValidator *validator = [CTCIntegerTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateFloatProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCFloatTypeValidator *validator = [CTCFloatTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateArrayProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCArrayTypeValidator *validator = [CTCArrayTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateDictionaryProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCDictionaryTypeValidator *validator = [CTCDictionaryTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateUnsignedIntegerProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCUnsignedIntegerTypeValidator *validator = [CTCUnsignedIntegerTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateDoubleProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCDoubleTypeValidator *validator = [CTCDoubleTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}

BOOL validateDateProperty(id self, SEL _cmd, id *ioValue, NSError *__autoreleasing* outError){
    CTCDateTypeValidator *validator = [CTCDateTypeValidator new];

    return [validator validateValue:ioValue error:outError];
}