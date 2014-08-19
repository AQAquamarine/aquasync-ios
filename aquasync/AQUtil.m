#import "AQUtil.h"

NSString *const kAQDeviceTokenKey = @"AQDeviceToken";

@implementation AQUtil

+ (NSNumber *)getCurrentTimestamp {
    return [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
}

+ (NSString *)getUUID {
    return [[[NSUUID UUID] UUIDString] lowercaseString];
};

// Gets device token. If device token is not stored, it automarically generate a token by UUID.
// @return UUID
+ (NSString *)getDeviceToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:kAQDeviceTokenKey];
    if (token) {
        return token;
    } else {
        return [self generateDeviceToken];
    }
};

+ (NSString *)joinString:(NSString *)aStr and:(NSString *)bStr {
    return [NSString stringWithFormat:@"%@%@", aStr, bStr];
};

+ (NSString *)parseInt:(NSInteger)aInt {
    return [NSString stringWithFormat:@"%d", aInt];
};

# pragma mark - Private Methods

+ (NSString *)generateDeviceToken {
    NSString *newToken = [self getUUID];
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:kAQDeviceTokenKey];
    return newToken;
};

@end
