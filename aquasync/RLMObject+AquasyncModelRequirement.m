#import "RLMObject+AquasyncModelRequirement.h"

@implementation RLMObject (AquasyncModelRequirement)

// Resolves conflict with considering which record is newer (localTimestamp).
// @param delta A delta. https://github.com/AQAquamarine/aquasync-protocol/blob/master/delta.md
- (void)aq_resolveConflict:(NSDictionary *)delta {
    long long  deltaTimestamp = [delta[@"localTimestamp"] longLongValue];
    if (deltaTimestamp > [[self valueForKey:@"localTimestamp"] longValue]) {
        [self updateFromDelta:delta];
    }
}

// Updates record from a delta.
// @param delta A delta. https://github.com/AQAquamarine/aquasync-protocol/blob/master/delta.md
- (void)updateFromDelta:(NSDictionary *)delta {
    [self updateWithBlock:^{
        [self aq_updateFromDictionary:delta];
    }];
}

// Makes the record undirty. (It automatically commits the change.)
- (void)undirty {
    [self updateWithBlock:^{
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"isDirty"];
    }];
};


@end
