#import "RLMObject+Serialization.h"

@implementation RLMObject (Serialization)

- (NSDictionary *)aq_toDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (RLMProperty *p in self.objectSchema.properties) {
        if([p.name isEqual:@"isDirty"]){continue;}
        dic[p.name] = [self valueForKey:p.name];
    }
    return dic;
};

@end