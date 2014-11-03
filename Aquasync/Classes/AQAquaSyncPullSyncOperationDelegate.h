//
//  AQAquaSyncPullSyncOperationDelegate.h
//  Aquasync
//
//  Created by kaiinui on 2014/11/03.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQAquaSyncPullSyncOperation;
@class AQDeltaPack;

/**
 *  A delegate protocol that used to pass the result of `AQAquaSyncPullSyncOperation`.
 *
 *  @see AQAquaSyncPullSyncOperation
 */
@protocol AQAquaSyncPullSyncOperationDelegate <NSObject>

/**
 *  A delegate method thath will be called
 *
 *  @param operation This opration
 *  @param deltaPack A DeltaPack obtained by serializing the response.
 */
- (void)pullSyncOperation:(AQAquaSyncPullSyncOperation *)operation didSuccessWithDeltaPack:(AQDeltaPack *)deltaPack;

/**
 *  A delegate method that will be called when the opration failed.
 *
 *  @param operation This operation
 *  @param error     An error describe the request error (AFNetworking format)
 */
- (void)pullSyncOperation:(AQAquaSyncPullSyncOperation *)operation didFailureWithError:(NSError *)error;

@end