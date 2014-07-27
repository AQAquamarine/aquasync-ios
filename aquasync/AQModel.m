#import "AQModel.h"

@implementation AQModel

@synthesize gid, deviceToken, isDirty, localTimestamp, deletedAt;

- (id)init {
    self = [super init];
    if (self) {
        [self beforeCreate];
        [self beforeUpdateOrCreate];
    }
    return self;
};

- (void)destroy {
    [self setDeletedAt:[NSDate new]];
};


- (id)get:(NSString *)key {
    return [self valueForKey:key];
};

- (void)set:(id)value forKey:(NSString *)key {
    [self beforeUpdateOrCreate];
    [self setValue:value forKey:key];
};

- (void)receiveDeltas {
    //for delta in deltas {
    //     record = [self find:gid]
    //     if (record) {
    //        [record resolveConflict]
    //     } else {
    //        [newInstance createFromDelta:delta]
    //     }
    //   }
    // [TODO]
};

- (NSArray *)extractDeltas {
    return [AQModel dirtyRecords];
};

+ (NSArray *)dirtyRecords {
    return @[
             @{
                 @"hoge": @"huga",
                 @"hogahoga": @"hugahuga"
                 },
             @{
                 @"huga": @"hugagahu",
                 @"hogahoga": @"hugahugasafsdf"
                 }
    ]; // [TODO]
};

// - @pragma mark Private Methods

- (void)beforeCreate {
    self.gid = [AQUtil getUUID];
    self.deviceToken = [AQUtil getDeviceToken];
};

- (void)beforeUpdateOrCreate {
    self.isDirty = true;
    self.localTimestamp = [AQUtil getCurrentTimestamp];
};

@end
