//
//  AQDeltaPack.m
//  Aquasync
//
//  Created by kaiinui on 2014/10/30.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQDeltaPack.h"

@interface AQDeltaPack ()

@property (nonatomic, strong) NSMutableDictionary *actualDictionary;

@end

@implementation AQDeltaPack

# pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _actualDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

# pragma mark - Inserting Deltas

- (void)addDelta:(AQDelta *)dictionary forKey:(NSString *)key {
    [[self deltaArrayForKey:key] addObject:dictionary];
}

- (void)addDeltasFromArray:(NSArray *)array forKey:(NSString *)key {
    [[self deltaArrayForKey:key] addObjectsFromArray:array];
}

# pragma mark - Getting Deltas

- (NSArray *)arrayForKey:(NSString *)key {
    return [self deltaArrayForKey:key];
}

# pragma mark - Helpers

- (NSMutableArray *)deltaArrayForKey:(NSString *)key {
    if (!self.actualDictionary[key]) {
        self.actualDictionary[key] = [[NSMutableArray alloc] init];
    }
    return self.actualDictionary[key];
}

@end
