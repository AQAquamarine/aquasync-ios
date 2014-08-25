#import "SerializableManagedObject.h"

@implementation SerializableManagedObject

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    // inversedDic =>
    //   @"gid": @"aq_gid"
    //   @"localTimestamp": @"aq_localTimestamp"
    NSDictionary *inversedJSONKeyMap = [[self class] helper_inverseDictionary:[[self class] JSONKeyMap]];
    for (NSString *inversedKey in inversedJSONKeyMap.allKeys) {
        NSString *dictionaryKey = inversedJSONKeyMap[inversedKey]; // @"aq_gid" for key = @"gid"
        id value = [self valueForKey:dictionaryKey];
        if (value == nil) { continue; }
        [dictionary setObject:value forKey:inversedKey]; // In dictionary, expect value for @"aq_gid" for key = @"gid"
    }
    return dictionary;
}

- (void)setValuesWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *keymap = [[self class] JSONKeyMap];
    for (NSString *objectKey in [keymap allKeys]) {
        [self setValueForObjectKey:objectKey withDictionary:dictionary];
    }
}

// Should be overrided.
+ (NSDictionary *)JSONKeyMap {
    return @{};
}

// Should be overrided.
+ (NSDictionary *)JSONValueTransformerNames {
    return @{};
}

# pragma mark - Private Methods

- (void)setValueForObjectKey:(NSString *)objectKey withDictionary:(NSDictionary *)dictionary {
    id dictionaryKey = [[self class] JSONKeyMap][objectKey];
    id value = dictionary[dictionaryKey];
    if (value == nil) { return; }
    id transformedValue = [self transformValue:value withObjectKey:objectKey];
    [self setValue:transformedValue forKey:objectKey];
}

- (id)transformValue:(id)value withObjectKey:(NSString *)objectKey {
    NSString *transformerName = [[self class] JSONValueTransformerNames][objectKey];
    if (!transformerName) { return value; }
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:transformerName];
    return [transformer transformedValue:value];
}

+ (NSDictionary *)helper_inverseDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *inverse = [[NSMutableDictionary alloc] init];
    for (NSString *key in dictionary.allKeys) {
        NSString *value = dictionary[key];
        [inverse setObject:key forKey:value];
    }
    return inverse;
}

@end

