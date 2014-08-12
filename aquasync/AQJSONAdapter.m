#import "AQJSONAdapter.h"

@implementation AQJSONAdapter

+ (NSDictionary *)serializeToJSONDictionary:(NSObject<AQJSONSerializeProtocol> *)obj {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSDictionary *keyMap = [[obj class] keyMap];
    for (NSString *key in keyMap) {
        NSString *jsonKey = keyMap[key];
        id value = [obj valueForKey:key];
        dic[jsonKey] = [self nilOrEmptyString:value];
    }
    return dic;
}

+ (NSObject<AQJSONSerializeProtocol> *)serializeFromJSONDictionary:(NSDictionary *)json withClass:(Class) klass{
    NSObject<AQJSONSerializeProtocol> *obj = [[klass alloc] init];
    [self update:obj withJSONDictionary:json];
    return obj;
}

+ (void)update:(NSObject<AQJSONSerializeProtocol> *)obj withJSONDictionary:(NSDictionary *)json {
    for (NSString *key in [[obj class] keyMap]) {
        NSString *jsonKey = [[obj class ]keyMap][key];
        [obj setValue:json[jsonKey] forKey:key];
    }
}

+ (NSString *)nilOrEmptyString:(id)value {
    if(value == nil) {
        return @"";
    }
    return value;
}

@end
