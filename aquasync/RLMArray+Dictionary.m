#import "RLMArray+Dictionary.h"

@implementation RLMArray (DictionaryMethods)

- (NSArray *)toDictionaryArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (RLMObject *object in self) {
        [array addObject:[object toDictionary]];
    }
    return array;
};

@end