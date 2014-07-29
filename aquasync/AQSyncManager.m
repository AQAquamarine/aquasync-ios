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
    [[[AQDeltaClient sharedInstance] pullDeltas:ust] subscribeNext:^(NSDictionary *JSON) {
        NSLog(@"%@", JSON[@"_id"]);
        for (NSString *model in JSON.allKeys) {
            if ([model isEqual: @"_id"]) {continue;}
            NSDictionary *deltas = JSON[model];
            [[self getModelClassFromName:model] aq_receiveDeltas: deltas];
        }
        
        NSLog(@"%@", JSON.allKeys);
        // [TODO] .then delta models each do AQModel aq_receiveDeltas};
    } error:^(NSError *error) {
        NSLog(@"%@", error);
        // [TODO] retry, or queuing. Reachability observing.
    }];
};

- (void)pushSync {
    NSDictionary *deltas = [self getDeltas];
    [[[AQDeltaClient sharedInstance] pushDeltas:deltas] subscribeNext:^(id JSON) {
        // [TODO] success, error handling
    } error:^(NSError *error) {
        NSLog(@"%@", error);
        // [TODO] error! have to retry?
    }];
};

- (id) getModelClassFromName:(NSString *)name {
    return models[name];
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
// [REFACTOR] should be handled by AQDeltaPackBuilder, or AQDeltaPack

- (int) getLatestUST {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:kAQLatestUSTKey];};

@end
