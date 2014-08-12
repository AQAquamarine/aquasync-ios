#import <Foundation/Foundation.h>

#import <Realm/Realm.h>
#import "Aquasync.h"

#import "RLMObject+Transaction.h"
#import "RLMObject+Serialization.h"
#import "RLMArray+Serialization.h"
#import "RLMObject+LogicalDeletion.h"
#import "RLMObject+AquasyncModelCallbacks.h"
#import "RLMObject+AquasyncModelManagerMethods.h"
#import "RLMObject+AquasyncModelRequirement.h"

@interface AQModel : RLMObject <AQModelManagerProtocol, AQAquasyncModelProtocol>

- (instancetype)initWithCallBack;
- (void)save;

@end
