#import "RLMObject+Dictionary.h"

@implementation RLMObject (DictionaryMethods)

- (NSDictionary *)aq_toDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (RLMProperty *p in self.objectSchema.properties) {
        dic[p.name] = [self valueForKey:p.name];
    }
    return dic;
};

@end