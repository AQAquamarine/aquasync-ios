//
//  AQAquaSyncService.m
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQAquaSyncService.h"

#import "AQAquaSyncPushSyncOperation.h"
#import "AQAquaSyncClient.h"
#import <AFHTTPRequestOperationManager.h>

# pragma mark - Command Notification Keys
/** @name Command Notification Keys */

NSString *const kAQAquaSyncRequestSynchronizationNotification = @"AQAquaSyncRequestSynchronization";

# pragma mark - Notification Keys
/** @name Notification Keys */

NSString *const kAQAquaSyncSynchronizationDidSuccessNotification = @"AQAquaSyncSynchronizationDidSuccess";
NSString *const kAQAquaSyncSynchronizationDidFailNotification = @"AQAquaSyncSynchronizationDidFail";

# pragma mark - Notification UserInfo Property Keys
/** @name Notification UserInfo Property Keys */

# pragma mark - kAQAquaSyncSynchronizationDidSuccessNotification UserInfo Property Keys

NSString *const kAQAquaSyncSynchronizationDidSuccessNotificationPushedDeltaPackKey = @"AQAquaSyncSynchronizationDidSuccessNotificationPushedDeltaPack";
NSString *const kAQAquaSyncSynchronizationDidSuccessNotificationPulledDeltaPackKey = @"AQAquaSyncSynchronizationDidSuccessNotificationPulledDeltaPack";

# pragma mark - kAQAquaSyncSynchronizationDidFailNotification UserInfo Property Keys

NSString *const kAQAquaSyncSynchronizationDidFailNotificationErrorKey = @"AQAquaSyncSynchronizationDidFailNotificationError";

# pragma mark -

@interface AQAquaSyncService ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) AQAquaSyncClient *client;
@property (nonatomic, strong) id<AQSyncableObjectAggregator> syncableObjectAggregator;

@end

@implementation AQAquaSyncService

- (instancetype)init {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    return [self initWithAFHTTPRequestOperationManager:manager];
}

- (instancetype)initWithAFHTTPRequestOperationManager:(AFHTTPRequestOperationManager *)manager {
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.client = [[AQAquaSyncClient alloc] initWithAFHTTPRequestOperationManager:manager];
    }
    return self;
}

- (instancetype)initWithSyncableObjectAggregator:(id<AQSyncableObjectAggregator>)syncableObjectAggregator {
    self = [super init];
    if (self) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.client = [[AQAquaSyncClient alloc] initWithAFHTTPRequestOperationManager:manager];
        self.syncableObjectAggregator = syncableObjectAggregator;
    }
    return self;
}

# pragma mark - Starting the Service

- (void)start {
#warning MOCK
    AQAquaSyncPushSyncOperation *operation = [[AQAquaSyncPushSyncOperation alloc] initWithSyncableObjectAggregator:self.syncableObjectAggregator delegate:self aquaSyncClient:self.client];
    [self.operationQueue addOperation:operation];
}

# pragma mark - AQAquaSyncPushSyncOperationDelegate

- (void)pushSyncOperation:(AQAquaSyncPushSyncOperation *)operation didSuccessWithDeltaPack:(AQDeltaPack *)deltaPack {
#warning TODO: Notification
}

- (void)pushSyncOperation:(AQAquaSyncPushSyncOperation *)operation didFailureWithError:(NSError *)error {
#warning TODO: Notification
}

@end
