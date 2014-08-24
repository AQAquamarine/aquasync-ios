#import "AQDeltaClient.h"

@implementation AQDeltaClient

@synthesize baseURI;

+ (instancetype)sharedInstance {
    static AQDeltaClient *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[AQDeltaClient alloc] init];
        _instance.manager = [[AFHTTPRequestOperationManager alloc] init];
        _instance.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return _instance;
};

# pragma mark - Public Methods

// Pushes DeltaPack to the backend.
// You should set baseURI before call the method.
// The protocol is described in https://github.com/AQAquamarine/aquasync-protocol#post-deltas
// @param deltapack A DeltaPack
// @return AFNetworking RACSignal
- (RACSignal *)pushDeltaPack:(NSDictionary *)deltapack {
    NSString *path = [AQUtil joinString:self.baseURI and:@"deltas"];
    return [self.manager rac_POST:path parameters:deltapack];
};

// Pulls DeltaPack from the backend.
// You should set baseURI before call the method.
// The protocol is described in https://github.com/AQAquamarine/aquasync-protocol#get-deltasfromust
// @param latestUST latestUST described in https://github.com/AQAquamarine/aquasync-protocol#get-deltasfromust
// @return AFNetworking RACSignal
- (RACSignal *)pullDeltaPack:(NSInteger)latestUST {
    NSString *beforeFrom = [AQUtil joinString:self.baseURI and:@"deltas/ust:"];
    NSString *path = [AQUtil joinString:beforeFrom and:[AQUtil parseInt:latestUST]];
    return [self.manager rac_GET:path parameters:nil];
};

// Set BASIC Authentication Header
// @param username
// @param password
- (void)setBasicAuthorizationWithUsername:(NSString *)username password:(NSString *)password {
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
};

@end