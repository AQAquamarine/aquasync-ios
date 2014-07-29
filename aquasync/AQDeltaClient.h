#import <Foundation/Foundation.h>
#import "Aquasync.h"
#import <AFNetworking.h>
#import <RACAFNetworking.h>
#import <ReactiveCocoa.h>

@interface AQDeltaClient : NSObject

@property (nonatomic, assign) NSString *baseURI;
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;

+ (instancetype)sharedInstance;
- (RACSignal *)pushDeltaPack:(NSDictionary *)deltapack;
- (RACSignal *)pullDeltaPack:(int)latestUST;

@end
