#import "RLMObject+LogicalDeletion.h"

@implementation RLMObject (LogicalDeletion)

+ (RLMArray *)all {
    return [self objectsWhere:@"isDeleted == false"];
}

+ (RLMArray *)where:(NSString *)query {
    return [[self all] objectsWhere:query];
}

// Destroys the object.
- (void)destroy {
    [self updateWithBlock:^{
        [self setValue:[NSNumber numberWithBool:YES] forKey:@"isDeleted"];
    }];
};

@end
