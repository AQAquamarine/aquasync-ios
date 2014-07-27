#import "Aquasync.h"
#import <Foundation/Foundation.h>

@interface AQSyncManager : NSObject

// MODEL_NAME: [Model class]
@property (nonatomic, retain) NSMutableDictionary *models;

+ (AQSyncManager *)sharedInstance;
- (void)sync;

- (NSDictionary *)getDeltas;

@end
