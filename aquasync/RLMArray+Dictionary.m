#import "RLMArray+Dictionary.h"

@implementation RLMArray (DictionaryMethods)

- (NSArray *)aq_toDictionaryArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (RLMObject *object in self) {
        [array addObject:[object aq_toDictionary]];
    }
    return array;
};

@end