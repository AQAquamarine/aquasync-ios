#import <Realm/Realm.h>

@interface RLMObject (Serialization)

- (NSDictionary *)aq_toDictionary;

@end