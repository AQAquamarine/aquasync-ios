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
#import "AQDeltaPack.h"

static const NSUInteger kAQAquaSyncPullSyncOperationFailCountThreshold = 5;

@interface AQAquaSyncPullSyncOperation ()

@property (nonatomic, assign) BOOL isFinished;

//{@dependencies
/**
 *  An AquaSync client dependency property for easier testing.
 *  Typically, it should be retained by `AQAquaSyncService` class.
 */
@property (nonatomic, weak) AQAquaSyncClient *client;
//}

@property (nonatomic, assign) NSUInteger failCount;
@property (nonatomic, strong) NSTimer *failTimer;

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

- (void)start {
    if (self.failTimer) {
        [self.failTimer invalidate];
        self.failTimer = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    NSInteger UST = [self.syncableObjectAggregator UST];
    NSString *deviceToken = [self.syncableObjectAggregator deviceToken];
    [self.client pullDeltaPackForUST:UST withDeviceToken:deviceToken success:^(AQDeltaPack *deltaPack) {
        [weakSelf.syncableObjectAggregator updateRecordsUsingDeltaPack:deltaPack];
        [weakSelf.syncableObjectAggregator setUST:deltaPack.UST];
        [weakSelf.delegate pullSyncOperation:weakSelf didSuccessWithDeltaPack:deltaPack];
        
        [weakSelf finishOperation];
    } failure:^(NSError *error) {
        [weakSelf didFailWithError:error];
    }];
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)finishOperation {
    [self willChangeValueForKey:@"isFinished"];
    self.isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

# pragma mark - Retryable Operation

- (void)didFailWithError:(NSError *)error {
    if (self.failCount >= kAQAquaSyncPullSyncOperationFailCountThreshold) {
        [self failOperationWithError:error];
        return;
    }
    self.failCount += 1;
    
    NSTimeInterval interval = [self waitForFailCount:self.failCount];
    self.failTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(start) userInfo:nil repeats:NO];
}

- (void)failOperationWithError:(NSError *)error {
    [self.delegate pullSyncOperation:self didFailureWithError:error];
    
    [self finishOperation];
}

- (NSTimeInterval)waitForFailCount:(NSUInteger)failCount {
    return pow(failCount, 2) * 2;
}

@end
