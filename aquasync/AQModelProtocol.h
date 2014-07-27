#import "Aquasync.h"
#import <Foundation/Foundation.h>

@protocol AQModelProtocol

+ (NSDictionary *)aq_extractDeltas;
+ (void)aq_receiveDeltas;

@end
