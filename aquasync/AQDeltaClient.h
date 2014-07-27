#import <Foundation/Foundation.h>
#import "Aquasync.h"
#import <AFNetworking.h>

@interface AQDeltaClient : NSObject

@property (nonatomic, assign) NSString *baseURI;

+ (instancetype)sharedInstance;
- (void)pushDeltas:(NSDictionary *)deltas;
- (void)pullDeltas:(int)latestUST;

@end
