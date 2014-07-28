#import <Foundation/Foundation.h>
#import "Aquasync.h"
#import <AFNetworking.h>
#import <RACAFNetworking.h>
#import <ReactiveCocoa.h>

@interface AQDeltaClient : NSObject

@property (nonatomic, assign) NSString *baseURI;

+ (instancetype)sharedInstance;
- (RACSignal *)pushDeltas:(NSDictionary *)deltas;
- (RACSignal *)pullDeltas:(int)latestUST;

@end
