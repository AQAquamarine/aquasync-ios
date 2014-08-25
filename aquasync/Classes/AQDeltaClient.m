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
- (void)pushDeltaPack:(NSDictionary *)deltapack success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    NSString *path = [AQUtil joinString:self.baseURI and:@"deltas"];
    [self.manager POST:path parameters:deltapack success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
};

// Pulls DeltaPack from the backend.
// You should set baseURI before call the method.
// The protocol is described in https://github.com/AQAquamarine/aquasync-protocol#get-deltasfromust
// @param latestUST latestUST described in https://github.com/AQAquamarine/aquasync-protocol#get-deltasfromust
- (void)pullDeltaPack:(NSInteger)latestUST success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock {
    NSString *beforeFrom = [AQUtil joinString:self.baseURI and:@"deltas/ust:"];
    NSString *path = [AQUtil joinString:beforeFrom and:[AQUtil parseInt:latestUST]];
    [self.manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 204) { return; }
        failureBlock(error);
    }];
};

// Set BASIC Authentication Header
// @param username
// @param password
- (void)setBasicAuthorizationWithUsername:(NSString *)username password:(NSString *)password {
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
};

@end