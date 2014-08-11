//
//  RLMObject+AquasyncModelManagerMethods.m
//  aquasync
//
//  Created by kaiinui on 2014/08/12.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "Aquasync.h"
#import "RLMObject+Dictionary.h"
#import "RLMObject+AquasyncModelManagerMethods.h"

@implementation RLMObject (AquasyncModelManagerMethods)

+ (void)aq_receiveDeltas:(NSArray *)deltas {
    NSLog(@"aq_receiveDelta: invoked. with %@", deltas);
    for (NSDictionary *delta in deltas) {
        NSLog(@"aq_receiveDelta: should negotiate delta: %@", delta);
        NSString *gid = delta[@"gid"];
        id<AQAquasyncModelProtocol> record = [self find:gid];
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

// New a record from a dictionary. (Typically from a delta.)
// It will not invoke beforeCreateOrUpdte / beforeUpdate.
// @param dictionary Unnamed root dictionary.
+ (instancetype)newFromDictionary:(NSDictionary *)dictionary {
    AQModel *model = [[self alloc] init];
    for (NSString *key in dictionary.allKeys) {
        [model setValue:dictionary[key] forKey:key];
    }
    return model;
};

// Creates a record from a dictionary and commits the change.
// It will not invoke beforeCreateOrUpdte / beforeUpdate.
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

// Makes the record undirty. (It automatically commits the change.)
- (void)undirty {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [self setValue:[NSNumber numberWithBool:NO] forKey:@"isDirty"];
    [realm addObject:self];
    [realm commitWriteTransaction];
};


@end
