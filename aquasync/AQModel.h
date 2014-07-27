//
//  AQModel.h
//  aquasync
//
//  Created by kaiinui on 2014/07/27.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AQModel : NSObject

@property (nonatomic, retain) NSString *gid, *deviceToken, *isDirty;
@property (nonatomic, assign) NSInteger localTimestamp;
@property (nonatomic, assign) NSDate *deletedAt;

@end
