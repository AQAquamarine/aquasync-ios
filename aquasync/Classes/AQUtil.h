#import <Foundation/Foundation.h>

NSString *const kAQDeviceTokenKey;

@interface AQUtil : NSObject

+ (NSNumber *)getCurrentTimestamp;
+ (NSString *)getUUID;
+ (NSString *)getDeviceToken;
+ (NSString *)joinString:(NSString *)aStr and:(NSString *)bStr;
+ (NSString *)parseInt:(NSInteger) aInt;

@end
