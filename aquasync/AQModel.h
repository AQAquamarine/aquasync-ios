#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Aquasync.h"

#import "RLMObject+AquasyncModelCallbacks.h"
#import "RLMObject+AquasyncModelManagerMethods.h"

@interface AQModel : RLMObject <AQModelManagerProtocol, AQAquasyncModelProtocol>

- (instancetype)init;
- (void)destroy;
- (id)get:(NSString *)key;
- (void)set:(id)value forKey:(NSString *)key;
- (void)save;

@end
