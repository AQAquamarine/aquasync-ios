//
//  AQDeltaPack.h
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  AQDelta represents a patch for an object.
 *
 *  For example,
 *
 *      AQDelta *delta = @{
 *          @"name": @"Harry Potter",
 *          @"author": @"James Bill",
 *          @"publishedDate": <#NSDate>
 *      };
 *
 *  Represents a patch for following object.
 *
 *      @interface Book
 *      @property NSString *name;
 *      @property NSString *author;
 *      @property NSDate *publishedDate;
 *      @end
 *
 *  AQDelta's type is typically `<NSString *, NSObject *>`, where `NSString` represents a KeyPath for property, `NSObject` represents a value for property.
 *
 *  AQDelta is typically contained in `AQDeltaPack`.
 */
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

# pragma mark - Getting Metadata
/** @name Getting Metadata */

/**
 *  Return the UUID of the DeltaPack.
 *
 *  @return The UUID of the DeltaPack.
 */
- (NSString *)UUID;

/**
 *  Return the UST of the DeltaPack.
 *
 *  @return The UST of the DeltaPack.
 */
- (NSInteger)UST;

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

# pragma mark - Transform from/to NSDictionary
/** @name Transform from/to NSDictionary */

/**
 *  Getting a dictionary representation.
 *
 *  @return A dictionary representation
 */
- (NSDictionary *)dictionaryRepresentation;

/**
 *  Instantiate a DeltaPack with a dictionary.
 *
 *  @param dictionary A dictionary using for instantiate a DeltaPack
 *
 *  @return A initialized DeltaPack
 */
+ (instancetype)deltaPackWithDictionary:(NSDictionary *)dictionary;

@end
