//
//  AQAquaSyncClient.m
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQAquaSyncClient.h"

#import <AFNetworking.h>
#import "AQDeltaPack.h"

@interface AQAquaSyncClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation AQAquaSyncClient

- (instancetype)initWithAFHTTPRequestOperationManager:(AFHTTPRequestOperationManager *)manager {
    self = [super init];
    if (self) {
        self.manager = manager;
    }
    return self;
}

# pragma mark - Perform Requests

- (void)pushDeltaPack:(AQDeltaPack *)deltaPack
              success:(AQAquaSyncClientPushSuccessBlock)success
              failure:(AQAquaSyncClientPushFailureBlock)failure {
    [self.manager POST:@"/deltas" parameters:[deltaPack dictionaryRepresentation]
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(deltaPack);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)pullDeltaPackForUST:(NSUInteger)UST
            withDeviceToken:(NSString *)deviceToken
                    success:(AQAquaSyncClientPullSuccessBlock)success
                    failure:(AQAquaSyncClientPullFailureBlock)failure {
    NSDictionary *params = @{
                             @"ust": @(UST),
                             @"device_token": deviceToken
                             };
    [self.manager GET:@"/deltas"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  success([AQDeltaPack deltaPackWithDictionary:responseObject]);
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  failure(error);
              }];
}

@end
