//
//  AQSyncableObjectAggregator.h
//  Aquasync
//
//  Created by kaiinui on 2014/11/03.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQDeltaPack;

/**
 *  A protocol that developers should implement for gathering / storing Aquasync-able objects.
 *  
 *  It has responsibility to gather objects that needs synchronization & store the DeltaPack.
 */
@protocol AQSyncableObjectAggregator <NSObject>

# pragma mark - Working with Pull Sync
/** @name Working with Pull Sync */

/**
 *  This method should store a new data and update existing data from DeltaPack.
 *  The method to merge a DeltaPack is described at https://github.com/AQAquamarine/aquasync-protocol#pullsync
 *
 *  Refer https://github.com/AQAquamarine/aquasync-protocol#pullsync for detailed description.
 *
 *  @param deltaPack A DeltaPack to merge.
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol#pullsync
 */
- (void)updateRecordsUsingDeltaPack:(AQDeltaPack *)deltaPack;

# pragma mark - Working with Push Sync
/** @name Working with Push Sync */

/**
 *  This method should return a number of object which needs synchronization.
 *
 *  @return A number of object that needs synchronization.
 */
- (NSUInteger)countObjectsNeedingSynchronization;

/**
 *  This method should return a DeltaPack for Push sync.
 *  The method to gather a DeltaPack is described at https://github.com/AQAquamarine/aquasync-protocol#pushsync
 *
 *  Refer https://github.com/AQAquamarine/aquasync-protocol#pushsync for detailed description.
 *
 *  @return A DeltaPack to push sync.
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol#pushsync
 */
- (AQDeltaPack *)deltaPackForSynchronization;

/**
 *  This method should mark the objects contained in given DeltaPack as pushed. (It means you should set `aq_isDirty` as `NO`).
 *  Make sure you should NOT mark as read if the object's `localTimestamp` is newer than the object extracted from the DeltaPack.
 *
 *  Refer https://github.com/AQAquamarine/aquasync-protocol#undirty for detailed description.
 *
 *  @param deltaPack A DeltaPack that contains pushed objects.
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol#undirty
 */
- (void)markAsPushedUsingDeltaPack:(AQDeltaPack *)deltaPack;

@end