//
//  AQAquaSyncClient.m
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQAquaSyncClient.h"

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

@end
