#import <Realm/Realm.h>
#import "RLMObject+Transaction.h"
#import "RLMObject+AquasyncModelCallbacks.h"

@interface RLMObject (LogicalDeletion)

+ (RLMArray *)all;
- (void)destroy;

@end
