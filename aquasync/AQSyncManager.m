#import "AQSyncManager.h"

@implementation AQSyncManager

@synthesize models;

+ (AQSyncManager *)sharedInstance {
    static AQSyncManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
};

- (instancetype)init {
    self = [super init];
    if (self) {
        self.models = [[NSMutableDictionary alloc] init];
    }
    return self;
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

- (NSDictionary *)getDeltas {
    NSMutableDictionary *deltas = [[NSMutableDictionary alloc] init];
    NSString *uuid = [AQUtil getUUID];
    [deltas setObject:uuid forKey:@"_id"];
    for(NSString* key in models) {
        id<AQModelProtocol> model = [models objectForKey:key];
        [deltas setObject:[model aq_extractDeltas] forKey:key];
    }
    return deltas;
};

@end
