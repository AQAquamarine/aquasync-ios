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
#import "AQRequestAuthenticationSpecification.h"

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

- (instancetype)initWithAFHTTPRequestOperationManager:(AFHTTPRequestOperationManager *)manager
               withRequestAuthenticationSpecification:(AQRequestAuthenticationSpecification *)requestAuthenticationSpecification {
    self = [super init];
    if (self) {
        self.manager = [self enchantAuthenticationStrategyForRequestOperationManager:manager
                                              withRequestAuthenticationSpecification:requestAuthenticationSpecification];
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

# pragma mark - Helpers (Authentication)

- (AFHTTPRequestOperationManager *)enchantAuthenticationStrategyForRequestOperationManager:(AFHTTPRequestOperationManager *)manager withRequestAuthenticationSpecification:(AQRequestAuthenticationSpecification *)specification {
    switch (specification.authenticationStrategy) {
        case AQRequestAuthenticationStrategyNone:
            return manager;
            break;
        case AQRequestAuthenticationStrategyBasic:
            return [self enchantBasicAuthenticationForRequestOperationManager:manager withRequestAuthenticationSpecification:specification];
            break;
        default:
            return manager;
            break;
    }
}

- (AFHTTPRequestOperationManager *)enchantBasicAuthenticationForRequestOperationManager:(AFHTTPRequestOperationManager *)manager withRequestAuthenticationSpecification:(AQRequestAuthenticationSpecification *)specification {
    AFHTTPRequestSerializer *serializer = [self basicAuthRequestSerializerWithRequestAuthenticationSpecification:specification];
    [manager setRequestSerializer:serializer];
    
    return manager;
}

- (AFHTTPRequestSerializer *)basicAuthRequestSerializerWithRequestAuthenticationSpecification:(AQRequestAuthenticationSpecification *)requestAuthenticationSpecification {
    AFHTTPRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setAuthorizationHeaderFieldWithUsername:requestAuthenticationSpecification.userToken password:requestAuthenticationSpecification.secretKey];
    
    return serializer;
}

@end
