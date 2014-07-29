#import "AQSyncManager.h"

NSString *const kAQLatestUSTKey = @"AQLatestUST";

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

- (void)sync {
    [self pullSync];
    [self pushSync];
};

// Regists a model which to be synchronized.
// @param klass ModelManager class
// @param name Model name to tie DeltaPack's model key and Model class.
- (void)registModelManager:(id)klass forName:(NSString *)name {
    models[name] = klass;
};

# pragma mark - Private Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.models = [[NSMutableDictionary alloc] init];
    }
    return self;
};

// Performs #pullSync described in https://github.com/AQAquamarine/aquasync-protocol#pullsync
- (void)pullSync {
    int ust = [self getLatestUST];
    [[[AQDeltaClient sharedInstance] pullDeltaPack:ust] subscribeNext:^(NSDictionary *deltapack) {
        [self parseAndSaveDeltaPack:deltapack];
    } error:^(NSError *error) {
        [self handleErrorInPullSync:error];
    }];
};

// Performs #pushSync described in https://github.com/AQAquamarine/aquasync-protocol#pushsync
- (void)pushSync {
    NSDictionary *deltapack = [self buildDeltaPack];
    [[[AQDeltaClient sharedInstance] pushDeltaPack:deltapack] subscribeNext:^(id JSON) {
        [self successPushSync:deltapack];
    } error:^(NSError *error) {
        [self handleErrorInPullSync:error];
    }];
};

// Saves push-succeed DeltaPack id.
// @param deltapack Pushed DeltaPack
- (void)successPushSync:(id)deltapack {
    NSLog(@"should save %@", deltapack[@"_id"]);
};

- (void)handleErrorInPushSync:(NSError *)error {
    NSLog(@"%@", error);
    // [TODO] error! have to retry?
};

// Unpack a DeltaPack and pass parsed deltas to [models aq_receiveDeltas:delta]
// @param deltapack DeltaPack Dictionary (https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md)
- (void)parseAndSaveDeltaPack:(NSDictionary *)deltapack {
    NSLog(@"%@", deltapack[@"_id"]);
    for (NSString *model in deltapack.allKeys) {
        if ([model isEqual: @"_id"]) {continue;}
        NSArray *deltas = deltapack[model];
        [[self getModelClassFromName:model] aq_receiveDeltas: deltas];
    }
};

- (void)handleErrorInPullSync:(NSError *)error {
    NSLog(@"%@", error);
    // [TODO] retry, or queuing. Reachability observing.
};


// Gets model class from registered models.
// @return ModelManager class
- (id)getModelClassFromName:(NSString *)name {
    return models[name];
};

// Collects and build DeltaPack from registered ModelManagers.
// @return DeltaPack Dictionary (https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md)
- (NSDictionary *)buildDeltaPack {// [REFACTOR] should be handled by AQDeltaPackBuilder, or AQDeltaPack
    NSMutableDictionary *deltas = [[NSMutableDictionary alloc] init];
    NSString *uuid = [AQUtil getUUID];
    deltas[@"_id"] = uuid;
    for(NSString* key in models) {
        id<AQModelManagerProtocol> model = [models objectForKey:key];
        [deltas setObject:[model aq_extractDeltas] forKey:key];
    }
    return deltas;
};

- (int)getLatestUST {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:kAQLatestUSTKey];
};

- (void)setLatestUST:(int)ust {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:ust forKey:kAQLatestUSTKey];
};

- (NSString *)getDeviceToken {
    return @"8932-3292-9323-9323"; // [TODO] mock implementation
};

@end
