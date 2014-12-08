//
//  AQPullSyncObserver.m
//  Aquasync
//
//  Created by kaiinui on 2014/12/08.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQPullSyncObserver.h"

#import "AQAquaSyncService.h"

@interface AQPullSyncObserver ()

@property (nonatomic, strong, readonly) AQPullSyncObserveBlock block;

@end

@implementation AQPullSyncObserver

# pragma mark - Instantiation

+ (instancetype)observerWithBlock:(AQPullSyncObserveBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(AQPullSyncObserveBlock)block {
    self = [super init];
    if (self) {
        _block = block;
        [self startObservation];
    }
    return self;
}

# pragma mark - Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - Observation

- (void)startObservation {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notification:)
                                                 name:kAQAquaSyncPullSyncDidSuccessNotification
                                               object:nil];
}

- (void)notification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    AQDeltaPack *deltaPack = userInfo[kAQAquaSyncPullSyncDidSuccessNotificationPulledDeltaPackKey];
    
    self.block(deltaPack);
}

@end
