//
//  AQAquaSyncPushSyncOperationDelegate.h
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQAquaSyncPushSyncOperation;
@class AQDeltaPack;

/**
 *  A delegate protocol that used to pass the result of `AQAquaSyncPushSyncOperation`.
 *
 *  @see AQAquaSyncPushSyncOperation
 */
@protocol AQAquaSyncPushSyncOperationDelegate <NSObject>

/**
 *  A delegate method thath will be called
 *
 *  @param operation This opration
 *  @param deltaPack A DeltaPack obtained by serializing the response.
 */
- (void)operation:(AQAquaSyncPushSyncOperation *)operation didSuccessWithDeltaPack:(AQDeltaPack *)deltaPack;

/**
 *  A delegate method that will be called when the opration failed.
 *
 *  @param operation This operation
 *  @param error     An error describe the request error (AFNetworking format)
 */
- (void)operation:(AQAquaSyncPushSyncOperation *)operation didFailureWithError:(NSError *)error;

@end