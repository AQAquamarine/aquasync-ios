#import <Realm/Realm.h>
#import "AQUtil.h"

@interface RLMObject (AquasyncModelCallbacks)

- (void)beforeCreate;
- (void)beforeSave;

// DEPRECATED
- (void)beforeUpdateOrCreate;

@end
