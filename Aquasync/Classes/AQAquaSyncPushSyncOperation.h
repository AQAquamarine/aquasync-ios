//
//  AQAquaSyncPushSyncOperation.h
//  
//
//  Created by kaiinui on 2014/10/30.
//
//

#import <Foundation/Foundation.h>

#import "AQAquaSyncPushSyncOperationDelegate.h"

//{@dependencies
@class AQAquaSyncClient;
//}

@protocol AQSyncableObjectAggregator;

/**
 *  An operation that performs pushSync described in https://github.com/AQAquamarine/aquasync-protocol#pushsync
 *  It returns its result by delegate. Implement `AQAquaSyncPushSyncOperationDelegate` to receive the result.
 *
 *  @see AQAquaSyncPushSyncOperationDelegate
 *  @see https://github.com/AQAquamarine/aquasync-protocol#pushsync
 */
@interface AQAquaSyncPushSyncOperation : NSOperation

- (instancetype)initWithSyncableObjectAggregator:(id<AQSyncableObjectAggregator>)syncableObjectAggregator delegate:(id<AQAquaSyncPushSyncOperationDelegate>)delegate aquaSyncClient:(AQAquaSyncClient *)client;

/**
 *  This operation delegates its result to the delegate.
 */
@property (nonatomic, weak) id<AQAquaSyncPushSyncOperationDelegate> delegate;

/**
 *  This operation delegates building & undirtying records to SyncableObjectAggregator. 
 */
@property (nonatomic, strong) id<AQSyncableObjectAggregator> syncableObjectAggregator;

@end
