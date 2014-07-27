#import "AQModel.h"

@implementation AQModel

@synthesize gid, deviceToken, isDirty, localTimestamp, deletedAt;

- init {
    [self beforeCreate];
};

- (void)destroy {
    [self setDeletedAt:[NSDate new]];
};

// - @pragma mark Private Methods

- (void)beforeCreate {
    self.gid = [AQUtil getUUID];
    self.deviceToken = [AQUtil getDeviceToken];
};

- (void)beforeUpdateOrCreate {
    self.isDirty = true;
    self.localTimestamp = [AQUtil getCurrentTimestamp];
};

@end
