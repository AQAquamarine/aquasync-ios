#import "RLMArray+Dictionary.h"

@implementation RLMObject (DictionaryMethods)

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (RLMProperty *p in self.objectSchema.properties) {
        dic[p.name] = [self valueForKey:p.name];
    }
    return dic;
};

@end