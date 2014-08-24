#import "AQSyncManager.h"

NSString *const kAQLatestUSTKey = @"AQLatestUST";
NSString *const kAQPushSyncSuccessNotificationName = @"Aquasync.PushSync.Success";
NSString *const kAQPushSyncFailureNotificationName = @"Aquasync.PushSync.Failure";
NSString *const kAQPullSyncSuccessNotificationName = @"Aquasync.PullSync.Success";
NSString *const kAQPullSyncFailureNotificationName = @"Aquasync.PullSync.Failure";

@implementation AQSyncManager

@synthesize models;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.models = [[NSMutableDictionary alloc] init];
    }
    return self;
};

+ (AQSyncManager *)sharedInstance {
    static AQSyncManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
};


# pragma mark - Public Methods

// Performs synchronization.
// Before call the method, you should set baseURI of AQDeltaClient.
// It will post notification via NSNotificationCenter as..
// 1. Aquasync.PushSync.Success
// 2. Aquasync.PushSync.Failure
// 3. Aquasync.PullSync.Success
// 4. Aquasync.PullSync.Failure
- (void)sync {
    [self pullSync];
    [self pushSync];
};

// Regists a model which to be synchronized.
// @param klass ModelManager class
// @param name Model name to tie DeltaPack's model key and Model class.
- (void)registModelManager:(Class)klass forName:(NSString *)name {
    models[name] = klass;
};

# pragma mark - Private Methods

// Performs #pullSync described in https://github.com/AQAquamarine/aquasync-protocol#pullsync
- (void)pullSync {
    int ust = [self getLatestUST];
    [[[AQDeltaClient sharedInstance] pullDeltaPack:ust] subscribeNext:^(NSDictionary *deltapack) {
        [self successPullSync:deltapack];
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

# pragma mark - PullSync Helpers

// Saves pulled DeltaPack.
// @param deltapack Pulled DeltaPack
- (void)successPullSync:(id)deltapack {
    [self parseAndSaveDeltaPack:deltapack];
    [self updateLatestUSTWithDeltaPack:deltapack];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQPullSyncSuccessNotificationName object:deltapack];
}

// Unpack a DeltaPack and pass parsed deltas to [models aq_receiveDeltas:delta]
// @param deltapack DeltaPack Dictionary (https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md)
- (void)parseAndSaveDeltaPack:(NSDictionary *)deltapack {
    for (NSString *model in deltapack.allKeys) {
        if ([model isEqualToString:@"_id"]) { continue; }
        NSArray *deltas = deltapack[model];
        [[self getModelClassFromName:model] aq_receiveDeltas: deltas];
    }
};

- (void)updateLatestUSTWithDeltaPack:(NSDictionary *)deltapack {
    long currentLatestUST = [self getLatestUST];
    for (NSString *model in deltapack.allKeys) {
        if ([model isEqualToString:@"_id"]) { continue; }
        NSArray *deltas = deltapack[model];
        for (NSDictionary *delta in deltas) {
            long latestUST = [delta[@"ust"] longValue];
            if (latestUST > currentLatestUST) { currentLatestUST = latestUST; }
        }
    }
    [self setLatestUST:currentLatestUST];
}

- (void)handleErrorInPullSync:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQPullSyncFailureNotificationName object:error];
};

# pragma mark - PushSync Helpers

// Saves push-succeed DeltaPack id and undirty records.
// @param deltapack Pushed DeltaPack
- (void)successPushSync:(id)deltapack {
    [self undirtyRecordsFromDeltaPack:deltapack];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQPushSyncSuccessNotificationName object:deltapack];
};

// Undirty records when pushSync is succeeded.
// @param deltapack A DeltaPack which is synced successfully.
- (void)undirtyRecordsFromDeltaPack:(NSDictionary *)deltapack {
    for (NSString *model in deltapack.allKeys) {
        if ([model isEqualToString:@"_id"]) { continue; }
        NSArray *deltas = deltapack[model];
        [[self getModelClassFromName:model] aq_undirtyRecordsFromDeltas:deltas];
    }
};

- (void)handleErrorInPushSync:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQPushSyncFailureNotificationName object:error];
};

# pragma mark - Helpers

// Gets model class from registered models.
// @return ModelManager class
- (Class)getModelClassFromName:(NSString *)name {
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
    return [AQUtil getDeviceToken];
};

@end
