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


// Resolves conflict with considering which record is newer (localTimestamp).
// @param delta A delta. https://github.com/AQAquamarine/aquasync-protocol/blob/master/delta.md
- (void)resolveConflict:(NSDictionary *)delta {
    long long  deltaTimestamp = [delta[@"localTimestamp"] longLongValue];
    if (deltaTimestamp > self.localTimestamp) {
        [self updateFromDelta:delta];
    } else {
        NSLog(@"Skipped update delta due to delta's local Timestamp is older than current record.");
    }
}

// Updates record from a delta.
// @param delta A delta. https://github.com/AQAquamarine/aquasync-protocol/blob/master/delta.md
- (void)updateFromDelta:(NSDictionary *)delta {
    [self updateWithBlock:^{
        [self aq_updateFromDictionary:delta];
    }];
}


@end
