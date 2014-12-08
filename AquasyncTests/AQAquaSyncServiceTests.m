//
//  AQAquaSyncServiceTests.m
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta.h>
#import <OCMock.h>

#import "AQAquaSyncService.h"
#import "AQAquaSyncPushSyncOperationDelegate.h"
#import "AQAquaSyncPullSyncOperationDelegate.h"
#import "AQDeltaPack.h"

@interface AQAquaSyncService () <AQAquaSyncPushSyncOperationDelegate, AQAquaSyncPullSyncOperationDelegate>

- (void)startSynchronizationOperation;

@end

@interface AQAquaSyncServiceTests : XCTestCase

@end

@implementation AQAquaSyncServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItImplementsAQAquaSyncPushSyncOperationDelegate {
    AQAquaSyncService *service = [[AQAquaSyncService alloc] init];
    
    expect(service).to.conformTo(@protocol(AQAquaSyncPushSyncOperationDelegate));
}

- (void)testItNotifiesPushSyncDidSuccessNotification {
    AQAquaSyncService *service = [[AQAquaSyncService alloc] init];
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect(^{
        [service pushSyncOperation:nil didSuccessWithDeltaPack:deltaPack];
    }).to.notify(kAQAquaSyncPushSyncDidSuccessNotification);
}

- (void)testItNotifiesPushSyncDidFailNotification {
    AQAquaSyncService *service = [[AQAquaSyncService alloc] init];
    NSError *error = [[NSError alloc] init];
    
    expect(^{
        [service pushSyncOperation:nil didFailureWithError:error];
    }).to.notify(kAQAquaSyncPushSyncDidFailNotification);
}

- (void)testItNotifiesPullSyncDidSuccessNotification {
    AQAquaSyncService *service = [[AQAquaSyncService alloc] init];
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect(^{
        [service pullSyncOperation:nil didSuccessWithDeltaPack:deltaPack];
    }).to.notify(kAQAquaSyncPullSyncDidSuccessNotification);
}

- (void)testItNotifiesPullSyncDidFailNotification {
    AQAquaSyncService *service = [[AQAquaSyncService alloc] init];
    NSError *error = [[NSError alloc] init];
    
    expect(^{
        [service pullSyncOperation:nil didFailureWithError:error];
    }).to.notify(kAQAquaSyncPullSyncDidFailNotification);
}

@end
