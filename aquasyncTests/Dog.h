#import <Foundation/Foundation.h>
#import "AQJSONSerializeProtocol.h"

@interface Dog : NSObject <AQJSONSerializeProtocol>

@property (nonatomic) NSString *dogName;
@property (nonatomic) NSString *ownerName;
@property (nonatomic) int age;

@end
