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
    int ust = [self getLatestUST];
    [[[AQDeltaClient sharedInstance] pullDeltas:ust] subscribeNext:^(id JSON) {
        // [TODO] .then delta models each do AQModel aq_receiveDeltas};
    }];
};

- (void)pushSync {
    NSDictionary *deltas = [self getDeltas];
    [[[[AQDeltaClient sharedInstance] pushDeltas:deltas] subscribeNext:^(id JSON) {
        // [TODO] success, error handling
    }];
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

- (int) getLatestUST {
    return 1234567; // [TODO] mock implementation
};

@end
