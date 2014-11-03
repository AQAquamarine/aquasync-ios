//
//  AQDeltaPackTests.m
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

#import "AQDeltaPack.h"

@interface AQDeltaPackTests : XCTestCase

@end

@implementation AQDeltaPackTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItAddAnObject {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    [deltaPack addDelta:@{@"hoge": @"whoa"} forKey:@"whoa"];
    
    expect([deltaPack arrayForKey:@"whoa"].firstObject).to.contain(@"hoge");
}

- (void)testItAddObjectsFromArray {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    NSArray *deltas = @[
                        @{
                            @"hoge": @"whoa"
                            },
                        @{
                            @"hoge": @"whoo"
                            },
                        @{
                            @"hoge": @"whoe"
                            }
                        ];
    
    [deltaPack addDeltasFromArray:deltas forKey:@"whoa"];
    
    expect([deltaPack arrayForKey:@"whoa"].count).to.equal(3);
    expect([deltaPack arrayForKey:@"whoa"].firstObject).to.contain(@"hoge");
}

- (void)testItReturnsDifferentArrayForDifferentKey {
    AQDeltaPack *aDeltaPack = [[AQDeltaPack alloc] init];
    [aDeltaPack addDelta:@{@"hoge": @"whoa"} forKey:@"a"];
    
    AQDeltaPack *bDeltaPack = [[AQDeltaPack alloc] init];
    [bDeltaPack addDelta:@{@"funa": @"whoa"} forKey:@"b"];
    
    expect([aDeltaPack arrayForKey:@"a"].firstObject).to.contain(@"hoge");
    expect([aDeltaPack arrayForKey:@"a"].firstObject).notTo.contain(@"funa");
    expect([bDeltaPack arrayForKey:@"b"].firstObject).to.contain(@"funa");
    expect([bDeltaPack arrayForKey:@"b"].firstObject).notTo.contain(@"hoge");
}

- (void)testItReturnsEmptyArrayForEmptyKey {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect([deltaPack arrayForKey:@"whoa"].count).to.equal(0);
}

- (void)testItReturnNilForArrayForKeyNil {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect([deltaPack arrayForKey:nil]).to.beNil;
}

- (void)testItDoesNotRaiseExceptionForAddingNil {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect(^{
        [deltaPack addDelta:nil forKey:@"whoa"];
    }).notTo.raiseAny();
}

- (void)testItDoesNotRaiseExceptionForAddingSomethingForNil {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect(^{
        [deltaPack addDelta:@{@"whoa": @"hoge"} forKey:nil];
    }).notTo.raiseAny();
}

- (void)testItDoesNotRaiseExceptionForAddingNilArray {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect(^{
        [deltaPack addDeltasFromArray:nil forKey:@"whoa"];
    }).notTo.raiseAny();
}

- (void)testItDoesNotRaiseExceptionForAddingSomeArrayForNil {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    expect(^{
        [deltaPack addDeltasFromArray:@[@{@"hoge": @"whoa"}] forKey:nil];
    }).notTo.raiseAny();
}

- (void)testItReturnsAppropriateDictionaryRepresentation {
    AQDeltaPack *deltaPack = [[AQDeltaPack alloc] init];
    
    [deltaPack addDelta:@{@"name": @"taro"} forKey:@"Author"];
    [deltaPack addDelta:@{@"name": @"jack"} forKey:@"Author"];
    [deltaPack addDeltasFromArray:@[
                                    @{
                                        @"title": @"harrypotter",
                                        @"author": @"taro"
                                        },
                                    @{
                                        @"title": @"aliceinwonderland",
                                        @"author": @"jack"
                                        }
                                    ] forKey:@"Book"];
    
    NSDictionary *dictionary = [deltaPack dictionaryRepresentation];
    expect(dictionary).to.contain(@"Author");
    expect(dictionary).to.contain(@"Book");
    expect(dictionary[@"Author"]).to.haveCountOf(2);
    expect(dictionary[@"Book"]).to.haveCountOf(2);
}

- (void)testItAQDeltaIsAnNSDictionary {
    expect([[AQDelta alloc] init]).to.beKindOf([NSDictionary class]);
}

@end
