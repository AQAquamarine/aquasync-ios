#import "AQUtil.h"

@implementation AQUtil

+ (long)getCurrentTimestamp {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)getUUID {
    return [[NSUUID UUID] UUIDString];
};

+ (NSString *)getDeviceToken {
    return @"MOCK"; // [TODO] implement getDeviceToken
};

+ (NSString *)joinString:(NSString *)aStr and:(NSString *)bStr {
    return [NSString stringWithFormat:@"%@%@", aStr, bStr];
};

+ (NSString *)parseInt:(NSInteger)aInt {
    return [NSString stringWithFormat:@"%d", aInt];
};

@end
