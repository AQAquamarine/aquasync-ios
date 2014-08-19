#import "FLMAlbum.h"

@implementation FLMAlbum

@synthesize title, gid, isDeleted, isDirty, localTimestamp, deviceToken;

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
};


@end
