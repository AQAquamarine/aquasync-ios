#import "AQUtil.h"

NSString *const kAQDeviceTokenKey = @"AQDeviceToken";

@implementation AQUtil

+ (long)getCurrentTimestamp {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)getUUID {
    return [[NSUUID UUID] UUIDString];
};

+ (NSString *)getDeviceToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:kAQDeviceTokenKey];
    if (token) {
        return token;
    } else {
        return [self setDeviceToken];
    }
};

+ (NSString *)joinString:(NSString *)aStr and:(NSString *)bStr {
    return [NSString stringWithFormat:@"%@%@", aStr, bStr];
};

+ (NSString *)parseInt:(NSInteger)aInt {
    return [NSString stringWithFormat:@"%d", aInt];
};

# pragma mark - Private Methods

+ (NSString *)setDeviceToken {
    NSString *newToken = [self getUUID];
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:kAQDeviceTokenKey];
    return newToken;
};

@end
