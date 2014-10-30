//
//  AQAquaSyncService.m
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQAquaSyncService.h"

@interface AQAquaSyncService ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation AQAquaSyncService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

# pragma mark - Starting the Service

- (void)start {
    
}

# pragma mark - AQAquaSyncPushSyncOperationDelegate

- (void)operation:(AQAquaSyncPushSyncOperation *)operation didSuccessWithDeltaPack:(AQDeltaPack *)deltaPack {
    
}

- (void)operation:(AQAquaSyncPushSyncOperation *)operation didFailureWithError:(NSError *)error {
    
}

@end
