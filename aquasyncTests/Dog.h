#import <Foundation/Foundation.h>
#import "AQJSONSerializeProtocol.h"

@interface Dog : NSObject <AQJSONSerializeProtocol>

@property (nonatomic) NSString *dogName;

@end
