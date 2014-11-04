//
//  AQAquaSyncPullSyncOperation.m
//  Aquasync
//
//  Created by kaiinui on 2014/11/03.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQAquaSyncPullSyncOperation.h"

#import "AQAquaSyncClient.h"
#import "AQSyncableObjectAggregator.h"

@interface AQAquaSyncPullSyncOperation ()

@property (nonatomic, assign) BOOL isFinished;

//{@dependencies
/**
 *  An AquaSync client dependency property for easier testing.
 *  Typically, it should be retained by `AQAquaSyncService` class.
 */
@property (nonatomic, weak) AQAquaSyncClient *client;
//}

@end

@implementation AQAquaSyncPullSyncOperation

# pragma mark - Initialization

- (instancetype)initWithSyncableObjectAggregator:(id<AQSyncableObjectAggregator>)syncableObjectAggregator
                                        delegate:(id<AQAquaSyncPullSyncOperationDelegate>)delegate
                                  aquaSyncClient:(AQAquaSyncClient *)client {
    self = [super init];
    if (self) {
        self.syncableObjectAggregator = syncableObjectAggregator;
        self.delegate = delegate;
        self.client = client;
    }
    return self;
}

# pragma mark - NSOperation

- (void)main {
    __weak typeof(self) weakSelf = self;
    NSInteger UST = [self.syncableObjectAggregator UST];
    NSString *deviceToken = [self.syncableObjectAggregator deviceToken];
    [self.client pullDeltaPackForUST:UST withDeviceToken:deviceToken success:^(AQDeltaPack *deltaPack) {
        [weakSelf.syncableObjectAggregator updateRecordsUsingDeltaPack:deltaPack];
#warning TODO:
        // [weakSelf.syncableObjectAggregator setUST:deltaPack.UST];
        [weakSelf.delegate pullSyncOperation:weakSelf didSuccessWithDeltaPack:deltaPack];
        
        weakSelf.isFinished = YES;
    } failure:^(NSError *error) {
        [weakSelf.delegate pullSyncOperation:weakSelf didFailureWithError:error];
        
        weakSelf.isFinished = YES;
    }];
}

- (BOOL)isConcurrent {
    return YES;
}

@end
