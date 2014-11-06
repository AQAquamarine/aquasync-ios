//
//  AQAquaSyncPullSyncOperationTests.m
//  Aquasync
//
//  Created by kaiinui on 2014/11/03.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta.h>
#import <OCMock.h>
#import <OHHTTPStubs.h>

#import "AQSyncableObjectAggregator.h"
#import "AQAquaSyncPullSyncOperation.h"
#import "AQAquaSyncPullSyncOperationDelegate.h"
#import "AQAquaSyncClient.h"
#import <AFNetworking.h>

@interface AQAquaSyncPullSyncOperationTests : XCTestCase

@end

@implementation AQAquaSyncPullSyncOperationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItInvokesDelegatesWhenSuccess {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"pullSync_deltas_200.json", nil) statusCode:200 headers:@{
                                                                                                                @"Content-Type": @"text/json"
                                                                                                                }];
    }];
    //
    
    id aggregatorMock = [OCMockObject niceMockForProtocol:@protocol(AQSyncableObjectAggregator)];
    id delegateMock = [OCMockObject niceMockForProtocol:@protocol(AQAquaSyncPullSyncOperationDelegate)];
    AQAquaSyncClient *client = [[AQAquaSyncClient alloc] initWithAFHTTPRequestOperationManager:[AFHTTPRequestOperationManager manager]];
    AQAquaSyncPullSyncOperation *operation = [[AQAquaSyncPullSyncOperation alloc] initWithSyncableObjectAggregator:aggregatorMock delegate:delegateMock aquaSyncClient:client];
    
    [[aggregatorMock expect] setUST:20000000];
    [[aggregatorMock expect] updateRecordsUsingDeltaPack:[OCMArg any]];
    [[delegateMock expect] pullSyncOperation:operation didSuccessWithDeltaPack:[OCMArg any]];
    
    OCMStub([aggregatorMock UST]).andReturn(10000000);
    OCMStub([aggregatorMock deviceToken]).andReturn(@"someuuid");
    
    [[[NSOperationQueue alloc] init] addOperation:operation];
    
    [aggregatorMock verifyWithDelay:0.1];
    [delegateMock verifyWithDelay:0.1];
    
    //
    [OHHTTPStubs removeAllStubs];
}

- (void)testItInvokesFailureDelegatesIfFailed {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:@"pullSync_deltas_500.json" statusCode:500 headers:nil];
    }];
    //
    
    id aggregatorMock = [OCMockObject niceMockForProtocol:@protocol(AQSyncableObjectAggregator)];
    id delegateMock = [OCMockObject niceMockForProtocol:@protocol(AQAquaSyncPullSyncOperationDelegate)];
    AQAquaSyncClient *client = [[AQAquaSyncClient alloc] initWithAFHTTPRequestOperationManager:[AFHTTPRequestOperationManager manager]];
    AQAquaSyncPullSyncOperation *operation = [[AQAquaSyncPullSyncOperation alloc] initWithSyncableObjectAggregator:aggregatorMock delegate:delegateMock aquaSyncClient:client];
    
    OCMStub([aggregatorMock UST]).andReturn(10000000);
    OCMStub([aggregatorMock deviceToken]).andReturn(@"someuuid");
    
    [[delegateMock expect] pullSyncOperation:operation didFailureWithError:[OCMArg any]];
    
    [[[NSOperationQueue alloc] init] addOperation:operation];
    
    [delegateMock verifyWithDelay:0.1];
    
    //
    [OHHTTPStubs removeAllStubs];
}

@end
