#import "AQUtil.h"

@implementation AQUtil

+ (int)getCurrentTimestamp {
    return [[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970] * 1000] integerValue];
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
