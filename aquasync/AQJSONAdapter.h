#import <Foundation/Foundation.h>
#import "AQJSONSerializeProtocol.h"

@interface AQJSONAdapter : NSObject

+ (NSDictionary *)serializeToJSONDictionary:(NSObject<AQJSONSerializeProtocol> *) obj;
+ (NSObject<AQJSONSerializeProtocol> *)serializeFromJSONDictionary:(NSDictionary *)json withClass:(Class)klass;
+ (void)update:(NSObject<AQJSONSerializeProtocol>*)obj withJSONDictionary:(NSDictionary *)json;

@end
