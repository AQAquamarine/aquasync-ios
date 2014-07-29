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

// New a record from a dictionary. (Typically from a delta.)
// @param dictionary Unnamed root dictionary.
+ (instancetype)newFromDictionary:(NSDictionary *)dictionary {
    AQModel *model = [[self alloc] init];
    for (NSString *key in dictionary.allKeys) {
        [model setValue:dictionary[key] forKey:key];
    }
    return model;
};

// Creates a record from a dictionary and commits the change.
// @param dictionary Unnamed root dictionary.
+ (void)createFromDictionary:(NSDictionary *)dictionary {
    NSLog(@"createFromDictionary");
    AQModel *model = [self newFromDictionary:dictionary];
    [model save];
};

// Find all dirty records.
// @return Dirty records
+ (RLMArray *)dirtyRecords {
    return [self objectsWhere:@"isDirty = true"];
};

// Find a record with gid.
// @return If found, it returns a record. It not, it returns nil.
+ (instancetype)find:(NSString *)gid {
    NSString *query = [NSString stringWithFormat:@"gid == '%@'", gid];
    NSLog(@"find: %@", query);
    return [self objectsWhere:query].firstObject;
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

+ (void)aq_receiveDeltas:(NSArray *)deltas {
    NSLog(@"aq_receiveDelta: invoked. with %@", deltas);
    for (NSDictionary *delta in deltas) {
        NSLog(@"aq_receiveDelta: should negotiate delta: %@", delta);
        NSString *gid = delta[@"gid"];
        AQModel *record = [self find:gid];
        NSLog(@"%@", record);
        if (record) {
            [record resolveConflict:delta];
        } else {
            [self createFromDictionary:delta];
        }
    }
};

+ (NSArray *)aq_extractDeltas {
    return [[AQModel dirtyRecords] aq_toDictionaryArray];
};

+ (void)aq_undirtyRecordsFromDeltas:(NSArray *)deltas {
    for (NSDictionary *delta in deltas) {
        NSString *gid = delta[@"gid"];
        AQModel *object = [self find:gid];
        [object undirty];
        // [TODO] negotiate localTimestamp
    }
};

# pragma mark - Private Methods

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
