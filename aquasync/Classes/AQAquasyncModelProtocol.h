#import <Foundation/Foundation.h>

@protocol AQAquasyncModelProtocol <NSObject>

@required

// Resolves conflict with considering which record is newer (localTimestamp).
// @param delta A delta. https://github.com/AQAquamarine/aquasync-protocol/blob/master/delta.md
- (void)aq_resolveConflict:(NSDictionary *)delta;

@end
