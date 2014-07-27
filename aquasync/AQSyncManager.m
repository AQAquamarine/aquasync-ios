#import "AQSyncManager.h"

@implementation AQSyncManager

+ (AQSyncManager *)sharedInstance {
    static AQSyncManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
};

- (void)sync {
    [self pullSync];
    [self pushSync];
};

- (void)pullSync {
    // deltas = [[AQClient sharedInstance] pullDeltas:latestUST];
    // delta.models.each do
    //   [AQModel receiveDeltas:deltas]
    // end
};

- (void)pushSync {
    // deltas = [AQDelta new]
    // models.each do
    //   deltas += [model getDeltas]
    // end
    // unless [[AQClient sharedInstance] pushDeltas: deltas]
    //   [[AQQueue sharedInstance] push:"pushDeltas" param:deltas]
};

@end
