#import "AQModel.h"

@implementation AQModel

@synthesize gid, deviceToken, isDirty, localTimestamp, isDeleted;

# pragma mark - Lifecycle

- (instancetype)initWithCallBack {
    self = [super init];
    if (self) {
        [self beforeCreate];
    }
    return self;
};

# pragma mark - Realm Extensions

// Commits the change.
- (void)save {
    [self updateWithBlock:^() {
        [self beforeSave];
    }];
};

@end
