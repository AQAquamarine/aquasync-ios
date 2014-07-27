#import <Foundation/Foundation.h>

@interface AQSyncManager : NSObject

+ (AQSyncManager *)sharedInstance;
- (void)sync;

@end
