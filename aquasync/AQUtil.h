#import <Foundation/Foundation.h>

@interface AQUtil : NSObject

+ (long)getCurrentTimestamp;
+ (NSString *)getUUID;
+ (NSString *)getDeviceToken;
+ (NSString *)joinString:(NSString *)aStr and:(NSString *)bStr;
+ (NSString *)parseInt:(NSInteger) aInt;

@end
