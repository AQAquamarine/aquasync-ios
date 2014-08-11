#import <Foundation/Foundation.h>
#import "Aquasync.h"
#import <Realm/Realm.h>
#import "AQAquasyncModelProtocol.h"

@interface AQModel : RLMObject <AQModelManagerProtocol, AQAquasyncModelProtocol>

- (instancetype)init;
- (void)destroy;
- (id)get:(NSString *)key;
- (void)set:(id)value forKey:(NSString *)key;
- (void)save;
+ (instancetype)find:(NSString *)gid;

@end
