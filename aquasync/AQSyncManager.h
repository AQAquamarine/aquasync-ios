#import "Aquasync.h"
#import <Foundation/Foundation.h>

@interface AQSyncManager : NSObject

// MODEL_NAME: [Model class]
@property (nonatomic, assign) NSDictionary *models;

+ (AQSyncManager *)sharedInstance;
- (void)sync;

@end
