#import "AQModel.h"

@implementation AQModel

@synthesize gid, deviceToken, isDirty, localTimestamp, isDeleted;

# pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self beforeCreate];
        [self beforeSave];
    }
    return self;
};

# pragma mark - Realm Extensions

// Makes the record undirty. (It automatically commits the change.)
- (void)undirty {
    [self updateWithBlock:^{
        self.isDirty = NO;
    }];
};

// Destroys the object.
- (void)destroy {
    [self updateWithBlock:^{
        self.isDeleted = YES;
        [self beforeSave];
    }];
};

// Commits the change.
- (void)save {
    [self updateWithBlock:^() {
        [self beforeSave];
    }];
};

@end
