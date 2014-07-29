#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RLMObject (DictionaryMethods)

- (NSDictionary *)aq_toDictionary;

@end