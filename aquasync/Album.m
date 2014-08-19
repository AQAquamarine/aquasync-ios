//
//  Album.m
//  aquasync
//
//  Created by kaiinui on 2014/08/19.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "Album.h"


@implementation Album

@dynamic title;

+ (NSDictionary *)JSONKeyMap {
    return @{
             @"title": @"Title"
             };
}

@end
