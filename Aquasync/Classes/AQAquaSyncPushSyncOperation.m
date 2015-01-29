//
//  AQAquaSyncPushSyncOperation.m
//  
//
//  Created by kaiinui on 2014/10/30.
//
//

#import "AQAquaSyncPushSyncOperation.h"

#import "AQDeltaPack.h"
#import "AQAquaSyncClient.h"

#import "AQSyncableObjectAggregator.h"

@interface AQAquaSyncPushSyncOperation ()

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

static const NSUInteger kAQAquaSyncPushSyncOperationFailCountThreshold = 5;

@implementation AQAquaSyncPushSyncOperation

- (instancetype)initWithSyncableObjectAggregator:(id<AQSyncableObjectAggregator>)syncableObjectAggregator
                                        delegate:(id<AQAquaSyncPushSyncOperationDelegate>)delegate
                                  aquaSyncClient:(AQAquaSyncClient *)client {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
        self.syncableObjectAggregator = syncableObjectAggregator;
    }
    return self;
}

# pragma mark - NSOperation

- (void)start {
    [self performOperation];
}

- (void)performOperation {
    AQDeltaPack *deltaPack = [self.syncableObjectAggregator deltaPackForSynchronization];
    __weak typeof(self) weakSelf = self;
    [self.client pushDeltaPack:deltaPack success:^(id response) {
        [weakSelf.delegate pushSyncOperation:weakSelf didSuccessWithDeltaPack:deltaPack];
        [weakSelf.syncableObjectAggregator markAsPushedUsingDeltaPack:deltaPack];
        
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
    if (self.failCount >= kAQAquaSyncPushSyncOperationFailCountThreshold) {
        [self failOperationWithError:error];
        return;
    }
    self.failCount += 1;
    
    NSTimeInterval interval = [self waitForFailCount:self.failCount];
    self.failTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(performOperation) userInfo:nil repeats:NO];
}

- (void)failOperationWithError:(NSError *)error {
    [self.delegate pushSyncOperation:self didFailureWithError:error];
    
    [self finishOperation];
}

- (NSTimeInterval)waitForFailCount:(NSUInteger)failCount {
    return pow(failCount, 2) * 2;
}

@end
