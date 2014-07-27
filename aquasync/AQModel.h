#import <Foundation/Foundation.h>
#import "Aquasync.h"

@interface AQModel : NSObject <AQModelProtocol>

@property (nonatomic, retain) NSString *gid, *deviceToken;
@property (nonatomic, assign) int localTimestamp;
@property (nonatomic, assign) Boolean isDirty;
@property (nonatomic, assign) NSDate *deletedAt;

- (id)init;
- (void)destroy;
- (id)get:(NSString *)key;
- (void)set:(id)value forKey:(NSString *)key;

@end
