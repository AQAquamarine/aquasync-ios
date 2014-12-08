//
//  AQPullSyncObserver.h
//  Aquasync
//
//  Created by kaiinui on 2014/12/08.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQDeltaPack;

typedef void(^AQPullSyncObserveBlock)(AQDeltaPack *deltaPack);

@interface AQPullSyncObserver : NSObject

+ (instancetype)observerWithBlock:(AQPullSyncObserveBlock)block;

@end
