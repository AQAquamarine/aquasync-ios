#import <Foundation/Foundation.h>

@interface AQSyncManager : NSObject

+ (AQSyncManager *)sharedIntance;
- (void)sync;

@end
