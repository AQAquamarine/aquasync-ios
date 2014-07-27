#import "Aquasync.h"
#import <Foundation/Foundation.h>

@protocol AQModelProtocol : NSObject

- (NSString *)aq_modelName;
- (NSDictionary *)aq_extractDeltas;
- (void)aq_receiveDeltas;

@end
