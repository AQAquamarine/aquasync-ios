//
//  AQAquaSyncService.h
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQAquaSyncPushSyncOperationDelegate.h"

//{@dependencies
@class AFHTTPRequestOperationManager;
//}

@protocol AQSyncableObjectAggregator;

/**
 *  A service class that implements Aquasync specification described in https://github.com/AQAquamarine/aquasync-protocol.
 *
 *  To start the service, call `- start`.
 *
 *  @warning You should retain this service instance in your singleton Service Locator class.
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol
 */
@interface AQAquaSyncService : NSObject <AQAquaSyncPushSyncOperationDelegate>

# pragma mark - Initialization
/** @name Initialization */

/**
 *  Instantiate and initialize the service.
 *
 *  @param manager Dependency
 *
 *  @return Initialized service
 */
- (instancetype)initWithAFHTTPRequestOperationManager:(AFHTTPRequestOperationManager *)manager;

/**
 *  Instantiate and initialize the service.
 *
 *  @param syncableObjectAggregator An object that implements AQSyncableObjectAggregator protocol.
 *
 *  @return Initialized service
 */
- (instancetype)initWithSyncableObjectAggregator:(id<AQSyncableObjectAggregator>)syncableObjectAggregator;

# pragma mark - Starting the Service
/** @name Starting the Service */

/**
 *  Starts its service.
 */
- (void)start;

@end
