#import "AQUtil.h"

#import <LUKeychainAccess.h>

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
    NSString *token = [[LUKeychainAccess standardKeychainAccess] stringForKey:kAQDeviceTokenKey];
    if (token == nil) {
        token = [self storeNewDeviceToken];
    }
    return token;
};

+ (NSString *)joinString:(NSString *)aStr and:(NSString *)bStr {
    return [NSString stringWithFormat:@"%@%@", aStr, bStr];
};

+ (NSString *)parseInt:(NSInteger)aInt {
    return [NSString stringWithFormat:@"%d", aInt];
};

# pragma mark - Private Methods

+ (NSString *)storeNewDeviceToken {
    NSString *token = [self generateDeviceToken];
    [[LUKeychainAccess standardKeychainAccess] setString:token forKey:kAQDeviceTokenKey];
    return token;
}

+ (NSString *)generateDeviceToken {
    NSString *newToken = [self getUUID];
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:kAQDeviceTokenKey];
    return newToken;
};

@end
