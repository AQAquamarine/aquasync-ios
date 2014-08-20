#import "AQModel.h"

@implementation AQModel


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
