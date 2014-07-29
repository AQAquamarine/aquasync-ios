#import "Aquasync.h"
#import <Foundation/Foundation.h>

extern NSString *const kAQLatestUSTKey;

@interface AQSyncManager : NSObject

// MODEL_NAME: [Model class]
@property (nonatomic, retain) NSMutableDictionary *models;

+ (AQSyncManager *)sharedInstance;
- (void)sync;
- (void)registModelManager:(id)klass forName:(NSString *)name;

@end
