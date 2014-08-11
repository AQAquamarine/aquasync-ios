#import "AQModel.h"

@implementation AQModel

@synthesize gid, deviceToken, isDirty, localTimestamp, isDeleted;

# pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self beforeCreate];
        [self beforeUpdateOrCreate];
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
    [self beforeUpdateOrCreate];
    [self setValue:value forKey:key];
};

# pragma mark - Realm Extensions

// Makes the record undirty. (It automatically commits the change.)
- (void)undirty {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.isDirty = false;
    [realm addObject:self];
    [realm commitWriteTransaction];
};

- (void)destroy {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.isDeleted = YES;
    [self beforeUpdateOrCreate];
    [realm addObject:self];
    [realm commitWriteTransaction];
};

// Commits the change.
- (void)save {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:self];
    [realm commitWriteTransaction];
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
    NSLog(@"updateFromDelta invoked: %@", delta);
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (NSString *key in delta.allKeys) {
        id value = delta[key];
        [self setValue:value forKey:key];
    }
    NSLog(@"%@", self);
    [realm commitWriteTransaction];
};


# pragma mark - AQModelProtocol Methods



@end
