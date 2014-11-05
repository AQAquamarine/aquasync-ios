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

#import "AQAquaSyncPushSyncOperationDelegate.h"
#import "AQAquaSyncPullSyncOperationDelegate.h"

# pragma mark - Command Notification Keys

NSString *const kAQAquaSyncRequestSynchronizationNotification = @"AQAquaSyncRequestSynchronization";

# pragma mark - Notification Keys

NSString *const kAQAquaSyncPushSyncDidSuccessNotification = @"AQAquaSyncPushSyncDidSuccess";
NSString *const kAQAquaSyncPushSyncDidFailNotification = @"AQAquaSyncPushSyncDidFail";
NSString *const kAQAquaSyncPullSyncDidSuccessNotification = @"AQAquaSyncPullSyncDidSuccess";
NSString *const kAQAquaSyncPullSyncDidFailNotification = @"AQAquaSyncPullSyncDidFail";

# pragma mark - Notification UserInfo Property Keys

# pragma mark - kAQAquaSyncPushSyncDidSuccessNotification UserInfo Property Keys

// AQDeltaPack
NSString *const kAQAquaSyncPushSyncDidSuccessNotificationPushedDeltaPackKey = @"AQAquaSyncPushSyncDidSuccessNotificationPushedDeltaPack";

# pragma mark - kAQAquaSyncPushSyncDidFailNotification UserInfo Property Keys

// NSError
NSString *const kAQAquaSyncPushSyncDidFailNotificationErrorKey = @"AQAquaSyncPushSyncDidFailNotificationError";

# pragma mark - kAQAquaSyncPullSyncDidSuccessNotification UserInfo Property Keys

// AQDeltaPack
NSString *const kAQAquaSyncPullSyncDidSuccessNotificationPulledDeltaPackKey = @"AQAquaSyncPullSyncDidSuccessNotificationPulledDeltaPack";

# pragma mark - kAQAquaSyncPullSyncDidFailNotification UserInfo Property Keys

// NSError
NSString *const kAQAquaSyncPullSyncDidFailNotificationErrorKey = @"AQAquaSyncPullSyncDidFailNotificationError";

# pragma mark -

@interface AQAquaSyncService () <AQAquaSyncPushSyncOperationDelegate, AQAquaSyncPullSyncOperationDelegate>

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
    NSDictionary *userInfo = @{
                               kAQAquaSyncPushSyncDidSuccessNotificationPushedDeltaPackKey: deltaPack
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQAquaSyncPushSyncDidSuccessNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)pushSyncOperation:(AQAquaSyncPushSyncOperation *)operation didFailureWithError:(NSError *)error {
    NSDictionary *userInfo = @{
                               kAQAquaSyncPushSyncDidFailNotificationErrorKey: error
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQAquaSyncPushSyncDidFailNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

# pragma mark - AQAquaSyncPullSyncOperationDelegate

- (void)pullSyncOperation:(AQAquaSyncPullSyncOperation *)operation didSuccessWithDeltaPack:(AQDeltaPack *)deltaPack {
    NSDictionary *userInfo = @{
                               kAQAquaSyncPullSyncDidSuccessNotificationPulledDeltaPackKey: deltaPack
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQAquaSyncPullSyncDidSuccessNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

- (void)pullSyncOperation:(AQAquaSyncPullSyncOperation *)operation didFailureWithError:(NSError *)error {
    NSDictionary *userInfo = @{
                               kAQAquaSyncPullSyncDidFailNotificationErrorKey: error
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQAquaSyncPullSyncDidFailNotification
                                                        object:nil
                                                      userInfo:userInfo];
}

@end
