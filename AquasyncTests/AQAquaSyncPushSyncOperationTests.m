//
//  AQAquaSyncPushSyncOperationTests.m
//  Aquasync
//
//  Created by kaiinui on 2014/11/03.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta.h>
#import <OCMock.h>
#import <OHHTTPStubs.h>

#import "AQSyncableObjectAggregator.h"
#import "AQAquaSyncPushSyncOperationDelegate.h"
#import "AQAquaSyncPushSyncOperation.h"
#import "AQAquaSyncClient.h"
#import <AFNetworking.h>
#import "AQDeltaPack.h"

@interface AQAquaSyncPushSyncOperationTests : XCTestCase

@end

@implementation AQAquaSyncPushSyncOperationTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testItInvokesDelegateMethodsWhenSuccess {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:@"pushSync_deltas_201.json" statusCode:201 headers:nil];
    }];
    //
    
    id aggregatorMock = [OCMockObject niceMockForProtocol:@protocol(AQSyncableObjectAggregator)];
    id delegateMock = [OCMockObject niceMockForProtocol:@protocol(AQAquaSyncPushSyncOperationDelegate)];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://example.com/"]];
    AQAquaSyncClient *client = [[AQAquaSyncClient alloc] initWithAFHTTPRequestOperationManager:manager];
    AQAquaSyncPushSyncOperation *operation = [[AQAquaSyncPushSyncOperation alloc] initWithSyncableObjectAggregator:aggregatorMock delegate:delegateMock aquaSyncClient:client];
    
    [[aggregatorMock expect] deltaPackForSynchronization];
    [[aggregatorMock expect] markAsPushedUsingDeltaPack:[OCMArg any]];
    [[delegateMock expect] pushSyncOperation:operation didSuccessWithDeltaPack:[OCMArg any]];
    
    [[[NSOperationQueue alloc] init] addOperation:operation];
    
    [delegateMock verifyWithDelay:0.1];
    [aggregatorMock verifyWithDelay:0.1];
    
    //
    [OHHTTPStubs removeAllStubs];
}

- (void)testItInvokesFailureDelegateIfFailure {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:@"pushSync_deltas_500.json" statusCode:500 headers:nil];
    }];
    //
    
    id aggregatorMock = [OCMockObject niceMockForProtocol:@protocol(AQSyncableObjectAggregator)];
    id delegateMock = [OCMockObject niceMockForProtocol:@protocol(AQAquaSyncPushSyncOperationDelegate)];
    AQAquaSyncClient *client = [[AQAquaSyncClient alloc] initWithAFHTTPRequestOperationManager:[AFHTTPRequestOperationManager manager]];
    AQAquaSyncPushSyncOperation *operation = [[AQAquaSyncPushSyncOperation alloc] initWithSyncableObjectAggregator:aggregatorMock delegate:delegateMock aquaSyncClient:client];
    
    [[delegateMock reject] pushSyncOperation:[OCMArg any] didFailureWithError:[OCMArg any]];
    
    [[[NSOperationQueue alloc] init] addOperation:operation];
    
    [delegateMock verifyWithDelay:0.1];
    
    //
    [OHHTTPStubs removeAllStubs];
}

@end
