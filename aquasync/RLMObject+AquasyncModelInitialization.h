#import <Realm/Realm.h>
#import "RLMObject+AquasyncModelCallbacks.h"

@interface RLMObject (AquasyncModelInitialization)

- (instancetype)init;
- (instancetype)initWithCallBack;
- (instancetype)initWithPure;

@end
