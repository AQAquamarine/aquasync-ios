#import <Realm/Realm.h>
#import "RLMObject+Transaction.h"
#import "RLMObject+AquasyncModelCallbacks.h"

@interface RLMObject (LogicalDeletion)

+ (RLMArray *)all;
+ (RLMArray *)where:(NSString *)query;
- (void)destroy;

@end
