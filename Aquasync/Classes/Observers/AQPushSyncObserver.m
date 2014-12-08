//
//  AQPushSyncObserver.m
//  Aquasync
//
//  Created by kaiinui on 2014/12/08.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQPushSyncObserver.h"

#import "AQAquaSyncService.h"

@interface AQPushSyncObserver ()

@property (nonatomic, strong, readonly) AQPushSyncObserveBlock block;

@end

@implementation AQPushSyncObserver

# pragma mark - Instantiation

+ (instancetype)observerWithBlock:(AQPushSyncObserveBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(AQPushSyncObserveBlock)block {
    self = [super init];
    if (self) {
        _block = block;
        [self startObservation];
    }
}

# pragma mark - Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma mark - Observation

- (void)startObservation {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notification:)
                                                 name:kAQAquaSyncPushSyncDidSuccessNotification
                                               object:nil];
}

- (void)notification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    AQDeltaPack *deltaPack = userInfo[kAQAquaSyncPushSyncDidSuccessNotificationPushedDeltaPackKey];
    
    self.block(deltaPack);
}

@end
