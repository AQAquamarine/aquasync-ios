#import "RLMObject+AquasyncModelCallbacks.h"

@implementation RLMObject (AquasyncModelCallbacks)

// This method should be called when object is created.
// set gid = generateUUID
// set deviceToken
// set isDeleted = NO
- (void)beforeCreate {
    [self setValue:[NSNumber numberWithBool:NO] forKey:@"isDeleted"];
    [self setValue:[AQUtil getUUID] forKey:@"gid"];
    [self setValue:[AQUtil getDeviceToken] forKey:@"deviceToken"];
};

// This method should be called when object is modified.
// set isDirty = YES
// set localTimestamp = currentTimestamp
//
// [Why NSNumber:numberWithBool; ?]
// http://stackoverflow.com/questions/7783490/arc-conversion-iphone-implicit-conversion-of-bool-aka-signed-char-to-id
- (void)beforeSave {
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isDirty"];
    [self setValue:[NSNumber numberWithLong:[AQUtil getCurrentTimestamp]] forKey:@"localTimestamp"];
};

- (void)beforeUpdateOrCreate {
    NSLog(@"DEPRECATED! use beforeSave instead of beforeUpdateOrCreate");
    [self beforeSave];
};

@end
