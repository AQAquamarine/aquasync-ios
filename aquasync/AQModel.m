#import "AQModel.h"

@implementation AQModel

@synthesize gid, deviceToken, isDirty, localTimestamp, isDeleted;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self beforeCreate];
        [self beforeUpdateOrCreate];
    }
    return self;
};

- (void)destroy {
    [self set:false forKey:@"isDeleted"];
};


- (id)get:(NSString *)key {
    return [self valueForKey:key];
};

- (void)set:(id)value forKey:(NSString *)key {
    [self beforeUpdateOrCreate];
    [self setValue:value forKey:key];
};

- (void)undirty {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    self.isDirty = false;
    [realm addObject:self];
    [realm commitWriteTransaction];
};

- (void)save {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:self];
    [realm commitWriteTransaction];
};

+ (instancetype)newFromDictionary:(NSDictionary *)dictionary {
    AQModel *model = [[self alloc] init];
    for (NSString *key in dictionary.allKeys) {
        [model setValue:dictionary[key] forKey:key];
    }
    return model;
};

+ (void)createFromDictionary:(NSDictionary *)dictionary {
    NSLog(@"createFromDictionary");
    AQModel *model = [self newFromDictionary:dictionary];
    [model save];
};

+ (RLMArray *)dirtyRecords {
    return [self objectsWhere:@"isDirty = true"];
};

+ (instancetype)find:(NSString *)gid {
    NSString *query = [NSString stringWithFormat:@"gid == '%@'", gid];
    NSLog(@"find: %@", query);
    return [self objectsWhere:query].firstObject;
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

- (void)resolveConflict:(NSDictionary *)delta {
    
}

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

- (void)beforeCreate {
    self.isDeleted = NO;
    self.gid = [AQUtil getUUID];
    self.deviceToken = [AQUtil getDeviceToken];
};

- (void)beforeUpdateOrCreate {
    self.isDirty = YES;
    self.localTimestamp = [AQUtil getCurrentTimestamp];
};

@end
