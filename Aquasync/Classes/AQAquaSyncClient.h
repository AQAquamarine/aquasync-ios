//
//  AQAquaSyncClient.h
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQDeltaPack;

//{@dependencies
@class AFHTTPRequestOperationManager;
//}

# pragma mark - Block Typedefs
/** @name Block Typedefs */

/**
 *  A block called when pushing succeed.
 *
 *  @param response JSON response
 */
typedef void(^AQAquaSyncClientPushSuccessBlock)(id response);

/**
 *  A block called if pushing failed.
 *
 *  @param error AFNetworking format `NSError`
 */
typedef void(^AQAquaSyncClientPushFailureBlock)(NSError *error);

/**
 *  A block called when pulling succeed
 *
 *  @param deltaPack DeltaPack that serialized from the response
 */
typedef void(^AQAquaSyncClientPullSuccessBlock)(AQDeltaPack *deltaPack);

/**
 *  A block called if pulling failed.
 *
 *  @param error AFNetworking format `NSError`
 */
typedef void(^AQAquaSyncClientPullFailureBlock)(NSError *error);

/**
 *  A networking class that wraps `AFHTTPRequestOperationManager`.
 */
@interface AQAquaSyncClient : NSObject

# pragma mark - Initialization
/** @name Initialization */

- (instancetype)initWithAFHTTPRequestOperationManager:(AFHTTPRequestOperationManager *)manager;

# pragma mark - Perform Requests
/** @name Perform Requests */

/**
 *  Pushes given DeltaPack to AquaSync Server.
 *
 *  @param deltaPack A DeltaPack to push
 *  @param success   Called when the request succeed with JSON response.
 *  @param failure   Called if the request failed with Error (AFNetworking format)
 */
- (void)pushDeltaPack:(AQDeltaPack *)deltaPack
              success:(AQAquaSyncClientPushSuccessBlock)success
              failure:(AQAquaSyncClientPushFailureBlock)failure;

/**
 *  Pulls DeltaPack from AquaSync Server
 *
 *  @param UST         Current UST
 *  @param deviceToken This device's deviceToken
 *  @param success     Called when the request succeed with DeltaPack response.
 *  @param failure     Called if the request failed with Error (AFNetworking format)
 */
- (void)pullDeltaPackForUST:(NSUInteger)UST
            withDeviceToken:(NSString *)deviceToken
                    success:(AQAquaSyncClientPullSuccessBlock)success
                    failure:(AQAquaSyncClientPullFailureBlock)failure;

@end
