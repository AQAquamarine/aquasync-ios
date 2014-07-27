#import "AQUtil.h"

@implementation AQUtil

+ (int)getCurrentTimestamp {
    return [[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970] * 1000] integerValue];
}

@end
