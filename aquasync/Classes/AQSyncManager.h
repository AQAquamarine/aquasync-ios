#import "AQModelManagerProtocol.h"
#import "AQDeltaClient.h"
#import <Foundation/Foundation.h>

extern NSString *const kAQLatestUSTKey;
extern NSString *const kAQPushSyncSuccessNotificationName;
extern NSString *const kAQPushSyncFailureNotificationName;

extern NSString *const kAQPullSyncSuccessNotificationName;
extern NSString *const kAQPullSyncFailureNotificationName;

@interface AQSyncManager : NSObject

// MODEL_NAME: [Model class]
@property (nonatomic, retain) NSMutableDictionary *models;

+ (AQSyncManager *)sharedInstance;
- (void)sync;
- (void)registModelManager:(Class)klass forName:(NSString *)name;

@end
