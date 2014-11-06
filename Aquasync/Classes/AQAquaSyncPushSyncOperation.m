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

@end

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

- (void)main {
    AQDeltaPack *deltaPack = [self.syncableObjectAggregator deltaPackForSynchronization];
    __weak typeof(self) weakSelf = self;
    [self.client pushDeltaPack:deltaPack success:^(id response) {
        [weakSelf.delegate pushSyncOperation:weakSelf didSuccessWithDeltaPack:deltaPack];
        [weakSelf.syncableObjectAggregator markAsPushedUsingDeltaPack:deltaPack];
        
        weakSelf.isFinished = YES;
    } failure:^(NSError *error) {
        [weakSelf.delegate pushSyncOperation:weakSelf didFailureWithError:error];
        
        weakSelf.isFinished = YES;
    }];
}

- (BOOL)isConcurrent {
    return YES;
}

@end
