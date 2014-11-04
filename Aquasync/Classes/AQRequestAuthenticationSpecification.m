//
//  AQRequestAuthenticationSpecification.m
//  Aquasync
//
//  Created by kaiinui on 2014/11/05.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQRequestAuthenticationSpecification.h"

@implementation AQRequestAuthenticationSpecification

- (instancetype)initWithUserToken:(NSString *)userToken
                        secretKey:(NSString *)secretKey
           authenticationStrategy:(AQRequestAuthenticationStrategy)authenticationStrategy {
    self = [super init];
    if (self) {
        _userToken = userToken;
        _secretKey = secretKey;
        _authenticationStrategy = authenticationStrategy;
    }
    return self;
}

@end
