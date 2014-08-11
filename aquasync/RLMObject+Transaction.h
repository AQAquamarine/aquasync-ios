#import <Realm/Realm.h>

@interface RLMObject (Transaction)

- (void)updateWithBlock:(void (^)(void)) updateBlock;

@end
