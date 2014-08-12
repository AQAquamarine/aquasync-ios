#import <Realm/Realm.h>
#import "RLMObject+Transaction.h"
#import "RLMObject+Serialization.h"
#import "RLMObject+AquasyncModelCallbacks.h"

@interface RLMObject (AquasyncModelRequirement)

- (void)resolveConflict:(NSDictionary *)delta;
- (void)undirty;

@end
