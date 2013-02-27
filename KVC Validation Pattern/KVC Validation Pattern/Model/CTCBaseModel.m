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

static NSMutableDictionary *modelProperties; // Dictionary used to convert json key's into classes proper-cased keys
static  dispatch_once_t onceToken;
static NSArray *propertyTypesArray;


#pragma mark - Class methods

+ (void)initialize {
    [super initialize];

    // Initialize will be called for each subclass. Since all subclasses will share the modelProperties
    // we do this in a dispatch_once block to ensure thread-safety
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
    // This method will build our class key mapping as well as adding our validation methods to the class dynamically
    [self hydrateModelProperties:[self class] translateDictionary:translateNameDict];
    // Each subclass has an entry in the modelProperties dictionary with all of it's property names,  we use the calculated
    // class name as the key.
    [modelProperties setObject:translateNameDict forKey:[self calculateClassName]];
}

+ (NSString *)calculateClassName {
    // This method is here because sometimes NSStringFromClass will return the class name with a - and some characters
    // after the class name.
    NSString *className = NSStringFromClass([self class]);
    NSRange ido = [className rangeOfString:@"-"];
    NSUInteger cdo = ido.location;
    if (cdo < className.length){
        className = [className substringFromIndex:cdo];
    }
    return className;
}

+ (void)hydrateModelProperties:(Class)class translateDictionary:(NSMutableDictionary *)translateDictionary {
    // This method is called recursively to find all the properties in each super class, up to NSObject, then
    // we stop.
    if (!class || class == [NSObject class]){
        return;
    }
	
    unsigned int outCount, i;
    // Get the class property list.
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++){
        objc_property_t p = properties[i];
        // Get the property name.
        const char *name = property_getName(p);
        NSString *nsName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        // The lower case property name will be the key in the dictionary
        NSString *lowerCaseName = [nsName lowercaseString];
        [translateDictionary setObject:nsName forKey:lowerCaseName];
        // Determine the string representation of the property type
        NSString *propertyType = [self getPropertyType:p];
        // Add a validation method for this property to the class
        [self addValidatorForProperty:nsName type:propertyType];
    }
    free(properties);

    // Call this method again with this classes super class to get properties defined on the super.
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

    // Look up the string property type in the propertyTypes array
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
        // This method creates the validation method name in the format of validate<KeyName>:error: format
        NSString *methodName = [self generateValidationMethodName:propertyName];
        // This will actually add the validation method to the class
        class_addMethod([self class], NSSelectorFromString(methodName), implementation, "c@:^@^@");
    }
}

+(NSString *)generateValidationMethodName:(NSString *)key{
    return [NSString stringWithFormat:@"validate%@:error:", [NSString capitalizeFirstCharacter:key]];
}


#pragma mark - Life cycle

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self){
        // This is where all the KVC magic begins.  This method can be called on an object that has already been
        // created.  This is just a convenience initializer.  The same thing could be accomplished in the following manner:
        //
        //   MySubClass *subClass = [MySubClass new];
        //  [subClass setValuesForKeysWithDictionary:dictionary];
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (NSString *)dictionaryKey {
    // This will cause this key to be generated once, on a per-class/per-instance basis.  This is done
    // because the logic in calculateClassName can be rather expensive when called repeatedly on
    // every property, for every class.
    dispatch_once(&keyToken, ^{
        _dictionaryKey = [[self class] calculateClassName];
    });
    return _dictionaryKey;
}


#pragma mark - KVC methods

- (void)setValue:(id)value forKey:(NSString *)key {
    // We can assume at this point, the key is not in proper case.  We will call the set value method
    // with proper casing NO and it will figure out the proper casing for the key (if it can)
    [self setValue:value forKey:key properCase:NO];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // We will look in the undefinedKeys Dictionary (should be defined in the subclass), and look for
    // this undefined key to see if the class maps the key to a know key.  This method is called automatically
    // by KVC if setValue:forKey: cannot find a property to match the key.  Also, we wanted to implement
    // this method in the base class, because the default implementation of this on NSObject throws
    // an exception.
    NSString *newKey = self.undefinedKeys[[key lowercaseString]];
    if (newKey){
        // If we have found the key, we will call our set value for key with proper case set to YES because
        // the key should be put into the dictionary in proper case.  If it is not, this will not work, and our value
        // will never be set.
        [self setValue:value forKey:newKey properCase:YES];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key properCase:(BOOL)properCase {
    // We first check to see if the key is already in proper case.  If not, we'll make it proper case.  This is done
    // because calling lowerCaseString on a string value can get expensive when called repeatedly.  That is what
    // will happen when setting a classes values from a dictionary as it will iteratively call setValue:forKey: on every
    // key it finds in the dictionary.
    if (!properCase) {
        NSString *lowerCaseKey = [key lowercaseString];
        // We do the lookup in the modelProperties dictionary for the proper cased key.  If we find it, we change
        // the key to be that value.
        NSString *properKey = modelProperties[self.dictionaryKey][lowerCaseKey];
        if (properKey){
            key = properKey;
        }
    }
	
    NSError *error = nil;
    // Here we call the validation logic.  Calling validateValue:forKey:error: will cause validate<key>:error: to be called
    // so all the validation methods we added dynamically to this class in initialize will no be utilised.
    BOOL isValid = [self validateValue:&value forKey:key error:&error];
	
    // We only want to set the value if the value is valid.
    if (isValid) {
        [super setValue:value forKey:key];
    }
}

@end