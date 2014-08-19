#import <Foundation/Foundation.h>

#import <Realm/Realm.h>
#import "Aquasync.h"

#import "AquasyncModelExtensions.h"

@interface AQModel : RLMObject <AQModelManagerProtocol, AQAquasyncModelProtocol>

- (instancetype)init;
- (instancetype)initWithCallBack;
- (instancetype)initWithPure;

@end
