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

# pragma mark - Public Methods

// Gets value.
- (id)get:(NSString *)key {
    return [self valueForKey:key];
};

// Sets value with invoking beforeUpdateOrCreate (so that the record will be dirty.)
- (void)set:(id)value forKey:(NSString *)key {
    [self beforeSave];
    [self setValue:value forKey:key];
};

# pragma mark - Realm Extensions

// Makes the record undirty. (It automatically commits the change.)
- (void)undirty {
    [self performChangeWithBlock:^{
        self.isDirty = NO;
    }];
};

- (void)destroy {
    [self performChangeWithBlock:^{
        self.isDeleted = YES;
        [self beforeSave];
    }];
};

// Commits the change.
- (void)save {
    [self performChangeWithBlock:^() {}];
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
    [self performChangeWithBlock:^{
        for (NSString *key in delta.allKeys) {
            id value = delta[key];
            [self setValue:value forKey:key];
        }
    }];
}

// Perform changes with transaction.
- (void)performChangeWithBlock:(void (^)(void))changes {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    changes();
    [realm commitWriteTransaction];
}

@end
