#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "RLMObject+Dictionary.h"

@interface RLMArray (DictionaryMethods)

- (NSArray *) toDictionaryArray;

@end