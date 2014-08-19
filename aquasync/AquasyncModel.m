#import "AquasyncModel.h"
#import "AQUtil.h"

@implementation AquasyncModel

@dynamic gid;
@dynamic deviceToken;
@dynamic localTimestamp;
@dynamic deleted;
@dynamic dirty;

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self != nil) {
        [self beforeCreate];
    }
    return self;
}

# pragma mark - Callback Methods

// This method should be called when object is created.
// set gid = generateUUID
// set deviceToken
// set isDeleted = NO
- (void)beforeCreate {
    self.deleted = NO;
    self.gid = [AQUtil getUUID];
    self.deviceToken = [AQUtil getDeviceToken];
};

// This method should be called when object is modified.
// set isDirty = YES
// set localTimestamp = currentTimestamp
- (void)beforeSave {
    self.dirty = YES;
    self.localTimestamp = [AQUtil getCurrentTimestamp];
};


@end
