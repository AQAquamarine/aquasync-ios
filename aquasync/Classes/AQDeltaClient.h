#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "AQUtil.h"

@interface AQDeltaClient : NSObject

@property (nonatomic, assign) NSString *baseURI;
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;

+ (instancetype)sharedInstance;
- (void)pushDeltaPack:(NSDictionary *)deltapack success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;
- (void)pullDeltaPack:(NSInteger)latestUST success:(void (^)(id JSON))successBlock failure:(void (^)(NSError *error))failureBlock;
- (void)setBasicAuthorizationWithUsername:(NSString *)username password:(NSString *)password;

@end
