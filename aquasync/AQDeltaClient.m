#import "AQDeltaClient.h"

@implementation AQDeltaClient

+ (instancetype)sharedInstance {
    static AQDeltaClient *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[AQDeltaClient alloc] init];
    });
    return _instance;
};

- (void)pushDeltas:(NSDictionary *)deltas {
    NSString *path = [AQUtil joinString:self.baseURI and:@"deltas"];
    NSLog(@"%@", path);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:deltas success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // [TODO] write Delta id to deltarecords
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // [TODO] retry or queue
    }];
};

- (void)pullDeltas:(NSInteger)latestUST {
    NSString *beforeFrom = [AQUtil joinString:self.baseURI and:@"deltas/from:"];
    NSString *path = [AQUtil joinString:beforeFrom and:[AQUtil parseInt:latestUST]];
    NSLog(@"%@", path);

    
    [[AFHTTPRequestOperationManager manager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // [TODO] pulled Deltas
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // [TODO] retry or queue
    }];
};


@end
