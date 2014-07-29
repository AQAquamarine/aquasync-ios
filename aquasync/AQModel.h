#import <Foundation/Foundation.h>
#import "Aquasync.h"
#import <Realm/Realm.h>

@interface AQModel : RLMObject <AQModelManagerProtocol>

@property (nonatomic, retain) NSString *gid, *deviceToken;
@property (nonatomic, assign) long localTimestamp;
@property (nonatomic, assign) BOOL isDirty, isDeleted;

- (instancetype)init;
- (void)destroy;
- (id)get:(NSString *)key;
- (void)set:(id)value forKey:(NSString *)key;
- (void)save;

@end
