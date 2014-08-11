#import <Realm/Realm.h>
#import "RLMObject+Serialization.h"

@interface RLMArray (Serialization)

- (NSArray *) aq_toDictionaryArray;

@end