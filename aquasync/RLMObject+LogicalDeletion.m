#import "RLMObject+LogicalDeletion.h"

@implementation RLMObject (LogicalDeletion)

+ (RLMArray *)all {
    return [self objectsWhere:@"isDeleted == false"];
}

@end
