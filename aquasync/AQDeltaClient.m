#import "AQDeltaClient.h"

@implementation AQDeltaClient

@synthesize baseURI;

+ (instancetype)sharedInstance {
    static AQDeltaClient *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[AQDeltaClient alloc] init];
    });
    return _instance;
};

- (RACSignal *)pushDeltaPack:(NSDictionary *)deltas {
    NSString *path = [AQUtil joinString:self.baseURI and:@"deltas"];
    return [[AFHTTPRequestOperationManager manager] rac_POST:path parameters:deltas];
};

- (RACSignal *)pullDeltaPack:(NSInteger)latestUST {
    NSString *beforeFrom = [AQUtil joinString:self.baseURI and:@"deltas/from:"];
    NSString *path = [AQUtil joinString:beforeFrom and:[AQUtil parseInt:latestUST]];
    return [[AFHTTPRequestOperationManager manager] rac_GET:path parameters:nil];
};


@end
