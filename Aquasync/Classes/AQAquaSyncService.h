//
//  AQAquaSyncService.h
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 *  A notification that will be posted when every PushSync processes succeed.
 *
 *  It contains following userInfo.
 *
 *  - userInfo
 *    - kAQAquaSyncPushSyncDidSuccessNotificationPushedDeltaPackKey: AQDeltaPack
 *
 *  For detailed information, @see [kAQAquaSyncPushSyncDidSuccessNotification UserInfo Property Keys]
 */
extern NSString *const kAQAquaSyncPushSyncDidSuccessNotification;

/**
 *  A notification that will be posted if any PushSync processes failed.
 *
 *  It contains following userInfo.
 *
 *  - userInfo
 *    - kAQAquaSyncPushSyncDidFailNotificationErrorKey: NSError
 *
 *  For detailed information, @see [kAQAquaSyncPushSyncDidFailNotification UserInfo Property Keys]
 */
extern NSString *const kAQAquaSyncPushSyncDidFailNotification;

/**
 *  A notification that will be posted when every PullSync processes succeed.
 *
 *  - userInfo
 *    - kAQAquaSyncPullSyncDidSuccessNotificationPulledDeltaPackKey: AQDeltaPack
 */
extern NSString *const kAQAquaSyncPullSyncDidSuccessNotification;

/**
 *  A notification that will be posted if any PullSync processes failed.
 *
 *  - userInfo
 *    - kAQAquaSyncPullSyncDidFailNotificationErrorKey: NSError
 */
extern NSString *const kAQAquaSyncPullSyncDidFailNotification;

# pragma mark - Notification UserInfo Property Keys
/** @name Notification UserInfo Property Keys */

# pragma mark - kAQAquaSyncPushSyncDidSuccessNotification UserInfo Property Keys
/** @name kAQAquaSyncPushSyncDidSuccessNotification UserInfo Property Keys */

/**
 *  A DeltaPack that used to push the changes.
 *
 *  @userInfo kAQAquaSyncPushSyncDidSuccessNotification
 *  @type AQDeltapack
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md
 */
extern NSString *const kAQAquaSyncPushSyncDidSuccessNotificationPushedDeltaPackKey;


# pragma mark - kAQAquaSyncPushSyncDidFailNotification UserInfo Property Keys
/** @name kAQAquaSyncPushSyncDidFailNotification UserInfo Property Keys */

/**
 *  @userInfo kAQAquaSyncPushSyncDidFailNotification
 *  @type NSError
 */
extern NSString *const kAQAquaSyncPushSyncDidFailNotificationErrorKey;

# pragma mark - kAQAquaSyncPullSyncDidSuccessNotification UserInfo Property Keys
/** @name kAQAquaSyncPullSyncDidSuccessNotification UserInfo Property Keys */

/**
 *  A DeltaPack that is pulled from the backend for synchronization.
 *  It contains full patch for perform synchronization.
 *
 *  @userInfo kAQAquaSyncPullSyncDidSuccessNotification
 *  @type AQDeltaPack
 *
 *  @see https://github.com/AQAquamarine/aquasync-protocol/blob/master/deltapack.md
 */
extern NSString *const kAQAquaSyncPullSyncDidSuccessNotificationPulledDeltaPackKey;

# pragma mark - kAQAquaSyncPullSyncDidFailNotification UserInfo Property Keys
/** @name kAQAquaSyncPullSyncDidFailNotification UserInfo Property Keys */

/**
 *  @userInfo kAQAquaSyncPullSyncDidFailNotification
 *  @type NSError
 */
extern NSString *const kAQAquaSyncPullSyncDidFailNotificationErrorKey;

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
@interface AQAquaSyncService : NSObject

# pragma mark - Initialization
/** @name Initialization */

/**
 *  Instantiate and initialize the service.
 *
 *  @param syncableObjectAggregator An object that implements AQSyncableObjectAggregator protocol.
 *  @param requestOperationmanager  manager Dependency
 *
 *  @return Initialized service
 */
- (instancetype)initWithSyncableObjectAggregator:(id<AQSyncableObjectAggregator>)syncableObjectAggregator
                     withRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager;

# pragma mark - Starting the Service
/** @name Starting the Service */

/**
 *  Starts its service.
 */
- (void)start;

/**
 *  Requests synchronization process.
 */
- (void)requestSynchronization;

@end
