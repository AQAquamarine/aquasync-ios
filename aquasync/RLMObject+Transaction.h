#import <Realm/Realm.h>
#import "RLMObject+AquasyncModelCallbacks.h"

@interface RLMObject (Transaction)

- (void)updateWithBlock:(void (^)(void)) updateBlock;
- (void)updateWithoutDirtyWithBlock:(void (^)(void)) updateBlock;
- (void)save;

@end
