#import "AquasyncModel.h"
#import "AQUtil.h"

@implementation AquasyncModel

@dynamic aq_gid;
@dynamic aq_deviceToken;
@dynamic aq_localTimestamp;
@dynamic aq_isDeleted;
@dynamic aq_isDirty;

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self != nil) {
        [self beforeCreate];
    }
    return self;
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
             @"aq_isDirty": @"isDirty"
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
- (void)beforeCreate {
    self.aq_isDeleted = NO;
    self.aq_gid = [AQUtil getUUID];
    self.aq_deviceToken = [AQUtil getDeviceToken];
};

// This method should be called when object is modified.
// set isDirty = YES
// set localTimestamp = currentTimestamp
- (void)beforeSave {
    self.aq_isDirty = YES;
    self.aq_localTimestamp = [AQUtil getCurrentTimestamp];
};


@end
