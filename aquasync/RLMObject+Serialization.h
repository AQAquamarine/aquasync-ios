#import <Realm/Realm.h>

@interface RLMObject (Serialization)

- (NSDictionary *)aq_toDictionary;
- (void)aq_updateFromDictionary:(NSDictionary *)dictionary;

@end