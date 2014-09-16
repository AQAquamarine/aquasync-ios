#import "AquasyncModel.h"
#import "AQUtil.h"

@implementation AquasyncModel

@dynamic aq_gid;
@dynamic aq_deviceToken;
@dynamic aq_localTimestamp;
@dynamic aq_isDeleted;
@dynamic aq_isDirty;

# pragma mark - Create

+ (instancetype)aq_create {
    return [[self create] beforeCreate];
}

# pragma mark - AQAquasyncModelProtocol

- (void)aq_resolveConflict:(NSDictionary *)delta {
    long deltaTimestamp = [delta[@"localTimestamp"] longValue];
    if (deltaTimestamp > [self.aq_localTimestamp longValue]) {
        [self aq_updateFromDelta:delta];
    }
}

# pragma mark - AQAquasyncModelProtocol Helpers (Private)

- (void)aq_updateFromDelta:(NSDictionary *)delta {
    [self setValuesWithDictionary:delta];
    [self saveWithOutCallback]; // DO NOT INVOKE CALLBACKS WHEN RESOLVING A DELTA!
}

# pragma mark - AQModelManagerProtocol

+ (void)aq_receiveDeltas:(NSArray *)deltas {
    for (NSDictionary *delta in deltas) {
        NSString *gid = delta[@"gid"];
        id<AQAquasyncModelProtocol> record = [self aq_find:gid];
        if (record) {
            [record aq_resolveConflict:delta];
        } else {
            [self aq_createWithDictionary:delta];
        }
    }
};

+ (NSArray *)aq_extractDeltas {
    return [self aq_dirtyRecordArrayWithDictionaryRepresentation];
};

+ (void)aq_undirtyRecordsFromDeltas:(NSArray *)deltas {
    for (NSDictionary *delta in deltas) {
        NSString *gid = delta[@"gid"];
        AquasyncModel *object = [self aq_find:gid];
        [object aq_undirty];
        // [TODO] negotiate localTimestamp
    }
};

# pragma mark - AQModelManagerProtocol Helpers (Private)

+ (NSArray *)aq_dirtyRecordArrayWithDictionaryRepresentation {
    NSMutableArray *records = [[NSMutableArray alloc] init];
    NSArray *dirtyRecords = [self aq_dirtyRecords];
    for (AquasyncModel *record in dirtyRecords) {
        [records addObject:[record dictionaryRepresentation]];
    }
    return records;
}

+ (void)aq_createWithDictionary:(NSDictionary *)dictionary {
    [[[self class] create] aq_updateFromDelta:dictionary]; // DO NOT INVOKE CALLBACK WHEN MERGING.
}

# pragma mark - Aliases

- (void)saveWithOutCallback {
    [self save];
}

# pragma mark - AquasyncModelManager Helper Methods

- (void)aq_undirty {
    self.aq_isDirty = NO;
    [self saveWithOutCallback]; // DO NOT INVOKE CALLBACKS!
}

+ (NSArray *)aq_dirtyRecords {
    return [self aq_where:@"aq_isDirty == true"];
}

# pragma mark - ActiveRecord Interfaces

+ (NSArray *)aq_where:(NSString *)query {
    NSString *notDeletedQuery = [NSString stringWithFormat:@"%@ AND aq_isDeleted != true", query];
    return [self where:notDeletedQuery];
}

+ (NSArray *)aq_all {
    return [self where:@"aq_isDeleted != true"];
}

+ (instancetype)aq_find:(NSString *)gid {
    NSString *query = [NSString stringWithFormat:@"aq_gid == '%@'", gid];
    return [self aq_where:query].firstObject;
}

- (void)aq_save {
    [self beforeSave];
    [self save];
}

- (void)aq_destroy{
    self.aq_isDeleted = YES;
    [self aq_save];
}

# pragma mark - SerializableManagedObject

+ (NSDictionary *)JSONKeyMap {
    return @{
             @"aq_gid": @"gid",
             @"aq_deviceToken": @"deviceToken",
             @"aq_localTimestamp": @"localTimestamp",
             @"aq_isDeleted": @"isDeleted",
             //@"aq_isDirty": @"isDirty" // BECAUSE isDirty is only in local. Refer spec.
             };
}

# pragma mark - SerializableManagedObject Helper

+ (NSDictionary *)JSONKeyMapWithDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *combinedDictionary = [[AquasyncModel JSONKeyMap] mutableCopy];
    [combinedDictionary addEntriesFromDictionary:dictionary];
    return combinedDictionary;
}

# pragma mark - Callback Methods

// This method should be called when object is created.
// set gid = generateUUID
// set deviceToken
// set isDeleted = NO
- (instancetype)beforeCreate {
    self.aq_isDeleted = NO;
    self.aq_gid = [AQUtil getUUID];
    self.aq_deviceToken = [AQUtil getDeviceToken];
    return self;
};

// This method should be called when object is modified.
// set isDirty = YES
// set localTimestamp = currentTimestamp
- (void)beforeSave {
    self.aq_isDirty = YES;
    self.aq_localTimestamp = [AQUtil getCurrentTimestamp];
};


@end
