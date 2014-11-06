//
//  AQRequestAuthenticationSpecification.h
//  Aquasync
//
//  Created by kaiinui on 2014/11/05.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AQRequestAuthenticationStrategy) {
    /**
     *  Do not do authentication
     */
    AQRequestAuthenticationStrategyNone,
    /**
     *  BASIC Authentication
     */
    AQRequestAuthenticationStrategyBasic
};

/**
 *  A data class that describe authentication information on HTTP request.
 */
@interface AQRequestAuthenticationSpecification : NSObject

/**
 *  A token that specifies a user.
 *  In Basic authentication, it is `username`.
 *  Typically, it is `email`.
 */
@property (nonatomic, copy, readonly) NSString *userToken;

/**
 *  A secret key that is used to authenticate a user with userToken.
 *  In Basic authentication, it is `password`.
 *  Typically, it is `password`.
 */
@property (nonatomic, copy, readonly) NSString *secretKey;

/**
 *  A type of authentication method.
 */
@property (nonatomic, assign, readonly) AQRequestAuthenticationStrategy authenticationStrategy;

- (instancetype)initWithUserToken:(NSString *)userToken
                        secretKey:(NSString *)secretKey
           authenticationStrategy:(AQRequestAuthenticationStrategy)authenticationStrategy;

@end
