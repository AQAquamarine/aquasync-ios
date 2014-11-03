//
//  AQDeltaPack.h
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSDictionary AQDelta;

/**
 *  A data class that represents DeltaPack described in https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md
 */
@interface AQDeltaPack : NSObject

# pragma mark - Inserting Deltas
/** @name Inserting Deltas */

/**
 *  Insert a delta for model.
 *
 *  @param delta A delta.
 *  @param key   A key that specifies the model for the delta.
 */
- (void)addDelta:(AQDelta *)delta forKey:(NSString *)key;

/**
 *  Insert deltas from array.
 *
 *  @param array An array that contains deltas. The type should be `AQDelta` as known as `NSDictionary`.
 *  @param key   A key that specifies the model for the delta.
 */
- (void)addDeltasFromArray:(NSArray /* <AQDelta *> */ *)array forKey:(NSString *)key;

# pragma mark - Getting Deltas
/** @name Getting Deltas */

/**
 *  Obtain an array that contains deltas that paired with given key.
 *
 *  @param key A key that specifies the model.
 *
 *  @return An array that contains deltas that paired with given key. The type is `AQDelta` as known as `NSDictionary`.
 */
- (NSArray /* <AQDelta> */ *)arrayForKey:(NSString *)key;

@end
