#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <RACAFNetworking.h>
#import <ReactiveCocoa.h>
#import "AQUtil.h"

@interface AQDeltaClient : NSObject

@property (nonatomic, assign) NSString *baseURI;
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;

+ (instancetype)sharedInstance;
- (RACSignal *)pushDeltaPack:(NSDictionary *)deltapack;
- (RACSignal *)pullDeltaPack:(int)latestUST;
- (void)setBasicAuthorizationWithUsername:(NSString *)username password:(NSString *)password;

@end
