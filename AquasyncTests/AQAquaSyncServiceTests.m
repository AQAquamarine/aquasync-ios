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

@end
