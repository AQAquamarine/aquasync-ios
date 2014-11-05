//
//  AQAquaSyncService.h
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQAquaSyncPushSyncOperationDelegate.h"

# pragma mark - Command Notification Keys
/** @name Command Notification Keys */

/**
 *  A notification that can be used to request synchronization to current AquaSync service.
 *  To invoke synhronization process, simply post the notification.
 */
extern NSString *const kAQAquaSyncRequestSynchronizationNotification;

# pragma mark - Notification Keys
/** @name Notification Keys */

/**
 *  A notification that will be posted when every synchronization processes succeed.
 *
 *  It contains following userInfo.
 *
 *  - userInfo
 *    - kAQAquaSyncSynchronizationDidSuccessNotificationPushedDeltaPackKey: AQDeltaPack
 *    - kAQAquaSyncSynchronizationDidSuccessNotificationPulledDeltaPackKey: AQDeltaPack
 *
 *  For detailed information, @see [kAQAquaSyncSynchronizationDidSuccessNotification UserInfo Property Keys]
 */
extern NSString *const kAQAquaSyncSynchronizationDidSuccessNotification;

/**
 *  A notification that will be posted if any synchroization processes failed.
 *
 *  It contains following userInfo.
 *
 *  - userInfo
 *    - kAQAquaSyncSynchronizationDidFailNotificationErrorKey: NSError
 *
 *  For detailed information, @see [kAQAquaSyncSynchronizationDidFailNotification UserInfo Property Keys]
 */
extern NSString *const kAQAquaSyncSynchronizationDidFailNotification;

# pragma mark - Notification UserInfo Property Keys
/** @name Notification UserInfo Property Keys */

# pragma mark - kAQAquaSyncSynchronizationDidSuccessNotification UserInfo Property Keys
/** @name kAQAquaSyncSynchronizationDidSuccessNotification UserInfo Property Keys */

/**
 *  A DeltaPack that used to push the changes.
 *
 *  @userInfo kAQAquaSyncSynchronizationDidSuccessNotification
 *  @type AQDeltapack
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md
 */
extern NSString *const kAQAquaSyncSynchronizationDidSuccessNotificationPushedDeltaPackKey;

/**
 *  A DeltaPack that is pulled from the backend for synchronization.
 *  It contains full patch for perform synchronization.
 *
 *  @userInfo kAQAquaSyncSynchronizationDidSuccessNotification
 *  @type AQDeltaPack
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md
 */
extern NSString *const kAQAquaSyncSynchronizationDidSuccessNotificationPulledDeltaPackKey;

# pragma mark - kAQAquaSyncSynchronizationDidFailNotification UserInfo Property Keys
/** @name kAQAquaSyncSynchronizationDidFailNotification UserInfo Property Keys */

/**
 *  @userInfo kAQAquaSyncSynchronizationDidFailNotification
 *  @type NSError
 */
extern NSString *const kAQAquaSyncSynchronizationDidFailNotificationErrorKey;

# pragma mark -

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
