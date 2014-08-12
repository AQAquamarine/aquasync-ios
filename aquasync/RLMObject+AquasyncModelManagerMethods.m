#import "RLMObject+AquasyncModelManagerMethods.h"

@implementation RLMObject (AquasyncModelManagerMethods)

+ (void)aq_receiveDeltas:(NSArray *)deltas {
    for (NSDictionary *delta in deltas) {
        NSString *gid = delta[@"gid"];
        id<AQAquasyncModelProtocol> record = [self find:gid];
        if (record) {
            [record aq_resolveConflict:delta];
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

// New a record from a dictionary. (Typically from a delta.)
// **It will not invoke beforeSave / beforeUpdate.**
// @param dictionary Unnamed root dictionary.
+ (instancetype)newFromDictionary:(NSDictionary *)dictionary {
    RLMObject *model = [[self alloc] initWithPure];
    [model aq_updateFromDictionary:dictionary];
    return model;
};

// Creates a record from a dictionary and commits the change.
// **It will not invoke beforeSave / beforeUpdate.**
// @param dictionary Unnamed root dictionary.
+ (void)createFromDictionary:(NSDictionary *)dictionary {
    RLMObject *model = [self newFromDictionary:dictionary];
    [model updateWithoutDirtyWithBlock:^{}];
};

// Find all dirty records.
// @return Dirty records
+ (RLMArray *)dirtyRecords {
    return [[self all] objectsWhere:@"isDirty = true"];
};

// Find a record with gid.
// @return If found, it returns a record. It not, it returns nil.
+ (instancetype)find:(NSString *)gid {
    NSString *query = [NSString stringWithFormat:@"gid == '%@'", gid];
    return [[self all] objectsWhere:query].firstObject;
};

@end
