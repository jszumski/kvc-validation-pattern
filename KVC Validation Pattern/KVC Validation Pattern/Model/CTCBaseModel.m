//
// CTCBaseModel
// KVC Validation Pattern
//
// Created by ncipollina on 2/18/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//

#import <objc/runtime.h>
#import "CTCBaseModel.h"
#import "NSString+Utilities.h"
#import "ValidationFunctions.h"

typedef NS_ENUM(NSUInteger, CTCPropertyType){
    CTCPropertyUnknown = 0,				// Property type is unknown
	CTCPropertyTypeString,				// Property is an NSString
	CTCPropertyTypeBool,				// Property is a BOOL
	CTCPropertyTypeNumber,				// Property is an NSNumber
	CTCPropertyTypeInteger,				// Property is an NSInteger
	CTCPropertyTypeFloat,				// Property is a float
	CTCPropertyTypeArray,				// Property is an NSArray
	CTCPropertyTypeMutableArray,		// Property is an NSMutableArray
	CTCPropertyTypeDictionary,			// Property is an NSDictionary
	CTCPropertyTypeMutableDictionary,	// Property is an NSMutableDictionary
	CTCPropertyTypeUnsignedInteger,		// Property is an NSUInteger
	CTCPropertyTypeDate,				// Property is an NSDate
	CTCPropertyTypeDouble				// Property is a double
};

@interface CTCBaseModel ()

@property (nonatomic, readwrite, strong) NSString *dictionaryKey;

@end

@implementation CTCBaseModel {
    dispatch_once_t keyToken;
}
static NSMutableDictionary *modelProperties;
static  dispatch_once_t onceToken;
static NSArray *propertyTypesArray;

+ (void)initialize {
    [super initialize];

    dispatch_once(&onceToken, ^{
        modelProperties = [NSMutableDictionary dictionary];
		
		// note this array's indexes MUST match the CTCPropertyType enum values for lookups to work properly
        propertyTypesArray = @[@"Unknown",												// CTCPropertyUnknown
							   @"NSString",												// CTCPropertyTypeString
							   [NSString stringWithFormat:@"%s",@encode(BOOL)],			// CTCPropertyTypeBool
							   @"NSNumber",												// CTCPropertyTypeNumber
							   [NSString stringWithFormat:@"%s",@encode(int)],			// CTCPropertyTypeInteger
							   [NSString stringWithFormat:@"%s",@encode(float)],		// CTCPropertyTypeFloat
							   @"NSArray",												// CTCPropertyTypeArray
							   @"NSMutableArray",										// CTCPropertyTypeMutableArray
							   @"NSDictionary",											// CTCPropertyTypeDictionary
							   @"NSMutableDictionary",									// CTCPropertyTypeMutableDictionary
							   [NSString stringWithFormat:@"%s",@encode(unsigned int)],	// CTCPropertyTypeUnsignedInteger
							   @"NSDate",												// CTCPropertyTypeDate
							   [NSString stringWithFormat:@"%s",@encode(double)]];		// CTCPropertyTypeDouble
    });
	
    NSMutableDictionary *translateNameDict = [NSMutableDictionary dictionary];
    [self hydrateModelProperties:[self class] translateDictionary:translateNameDict];
    [modelProperties setObject:translateNameDict forKey:[self calculateClassName]];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (NSString *)dictionaryKey {
    dispatch_once(&keyToken, ^{
        _dictionaryKey = [[self class] calculateClassName];
    });
    return _dictionaryKey;
}

#pragma mark - KVC methods

- (void)setValue:(id)value forKey:(NSString *)key {
    [self setValue:value forKey:key properCase:NO];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSString *newKey = self.undefinedKeys[[key lowercaseString]];
    if (newKey){
        [self setValue:value forKey:newKey properCase:YES];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key properCase:(BOOL)properCase {
    if (!properCase) {
        NSString *lowerCaseKey = [key lowercaseString];
        NSString *properKey = modelProperties[self.dictionaryKey][lowerCaseKey];
        if (properKey){
            key = properKey;
        }
    }

    NSError *error = nil;
    BOOL isValid = [self validateValue:&value forKey:key error:&error];

    if (isValid) {
        [super setValue:value forKey:key];
    }
}


+ (NSString *)calculateClassName {
    NSString *className = NSStringFromClass([self class]);
    NSRange ido = [className rangeOfString:@"-"];
    NSUInteger cdo = ido.location;
    if (cdo < className.length){
        className = [className substringFromIndex:cdo];
    }
    return className;
}

+ (void)hydrateModelProperties:(Class)class translateDictionary:(NSMutableDictionary *)translateDictionary {
    if (!class || class == [NSObject class]){
        return;
    }

    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++){
        objc_property_t p = properties[i];
        const char *name = property_getName(p);
        NSString *nsName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        NSString *lowerCaseName = [nsName lowercaseString];
        [translateDictionary setObject:nsName forKey:lowerCaseName];
        NSString *propertyType = [self getPropertyType:p];
        [self addValidatorForProperty:nsName type:propertyType];
    }
    free(properties);

    [self hydrateModelProperties:class_getSuperclass(class) translateDictionary:translateDictionary];
}

+ (NSString *)getPropertyType:(objc_property_t)property {
    if (!property) {
        return nil;
    }
    const char *propertyType = NULL, *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL){
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // It's a C primitive type:
            // C primitive types always start with T and not @, ie Ti == Integer
            propertyType = (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            propertyType = "id";
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            // Objects begin with T@ and have the actual class name enclosed in parenthesis
            propertyType = (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }

    return [[NSString alloc] initWithCString:propertyType encoding:NSUTF8StringEncoding];
}

+ (void)addValidatorForProperty:(NSString *)propertyName type:(NSString *)propertyType {
    IMP implementation;
    CTCPropertyType type;

    NSUInteger n = [propertyTypesArray indexOfObject:propertyType];

    if (n == NSNotFound){
        type = CTCPropertyUnknown;
    } else {
        type = (CTCPropertyType)n;
    }

    switch (type){
        case CTCPropertyTypeString:
            implementation = (IMP)validateStringProperty;
            break;
        case CTCPropertyTypeBool:
            implementation = (IMP)validateBoolProperty;
            break;
        case CTCPropertyTypeNumber:
            implementation = (IMP)validateNumberProperty;
            break;
        case CTCPropertyTypeInteger:
            implementation = (IMP)validateIntegerProperty;
            break;
        case CTCPropertyTypeFloat:
            implementation = (IMP)validateFloatProperty;
            break;
        case CTCPropertyTypeArray:
        case CTCPropertyTypeMutableArray:
            implementation = (IMP)validateArrayProperty;
            break;
        case CTCPropertyTypeDictionary:
        case CTCPropertyTypeMutableDictionary:
            implementation = (IMP)validateDictionaryProperty;
            break;
        case CTCPropertyTypeUnsignedInteger:
            implementation = (IMP)validateUnsignedIntegerProperty;
            break;
        case CTCPropertyTypeDate:
            implementation = (IMP)validateDateProperty;
            break;
        case CTCPropertyTypeDouble:
            implementation = (IMP)validateDoubleProperty;
            break;
        default:
            implementation = nil;
            break;
    }
    if (implementation){
        NSString *methodName = [self generateValidationMethodName:propertyName];
        class_addMethod([self class], NSSelectorFromString(methodName), implementation, "c@:^@^@");
    }
}

+(NSString *)generateValidationMethodName:(NSString *)key{
    return [NSString stringWithFormat:@"validate%@:error:", [NSString capitalizeFirstCharacter:key]];
}

@end