#import "AQModel.h"

@implementation AQModel

@synthesize gid, deviceToken, isDirty, localTimestamp, isDeleted;

- (instancetype)init {
    return [self initWithCallBack];
}

- (instancetype)initWithCallBack {
    self = [super init];
    if (self) {
        [self beforeCreate];
    }
    return self;
}

- (instancetype)initWithPure {
    self = [super init];
    return self;
}

@end
