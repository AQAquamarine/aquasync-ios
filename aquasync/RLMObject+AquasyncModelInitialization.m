#import "RLMObject+AquasyncModelInitialization.h"

@implementation RLMObject (AquasyncModelInitialization)

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
