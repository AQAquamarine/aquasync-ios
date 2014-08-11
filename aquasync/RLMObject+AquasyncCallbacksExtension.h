#import <Realm/Realm.h>

@interface RLMObject (AquasyncCallbacksExtension)

- beforeCreate;
- beforeCreateOrUpdate;

@end

@implementation RLMObject (AquasyncCallbacksExtension)

// [Aquasync Model Requirement]
// This method should be called when object is created.
// set gid = generateUUID
// set deviceToken
// set isDeleted = NO
- (void)beforeCreate {
    self.isDeleted = NO;
    self.gid = [AQUtil getUUID];
    self.deviceToken = [AQUtil getDeviceToken];
};

// [Aquasync Model Requirement]
// This method should be called when object is modified.
// set isDirty = YES
// set localTimestamp = currentTimestamp
- (void)beforeUpdateOrCreate {
    self.isDirty = YES;
    self.localTimestamp = [AQUtil getCurrentTimestamp];
};

@end
