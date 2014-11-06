//
//  AQAquaSyncPullSyncOperation.h
//  Aquasync
//
//  Created by kaiinui on 2014/11/03.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQAquaSyncPullSyncOperationDelegate.h"

//{@dependencies
@class AQAquaSyncClient;
//}

@protocol AQSyncableObjectAggregator;

/**
 *  An operation that performs pullSync described in https://github.com/AQAquamarine/aquasync-protocol#pullsync
 *  It returns its result by delegate. Implement `AQAquaSyncPullSyncOperationDelegate` to receive the result.
 *
 *  @see AQAquaSyncPullSyncOperationDelegate
 *  @see https://github.com/AQAquamarine/aquasync-protocol#pullsync
 */
@interface AQAquaSyncPullSyncOperation : NSOperation

- (instancetype)initWithSyncableObjectAggregator:(id<AQSyncableObjectAggregator>)syncableObjectAggregator
                                        delegate:(id<AQAquaSyncPullSyncOperationDelegate>)delegate
                                  aquaSyncClient:(AQAquaSyncClient *)client;

/**
 *  This operation delegates its result to the delegate.
 */
@property (nonatomic, weak) id<AQAquaSyncPullSyncOperationDelegate> delegate;

/**
 *  This operation delegates storing obtained DeltaPack to SyncableObjectAggregator.
 */
@property (nonatomic, strong) id<AQSyncableObjectAggregator> syncableObjectAggregator;

@end
