#import <Foundation/Foundation.h>

@interface AQSyncManager : NSObject

@property (nonatomic, assign) NSMutableArray *models;

+ (AQSyncManager *)sharedInstance;
- (void)sync;

@end
