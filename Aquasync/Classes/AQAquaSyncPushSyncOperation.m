//
//  AQAquaSyncPushSyncOperation.m
//  
//
//  Created by kaiinui on 2014/10/30.
//
//

#import "AQAquaSyncPushSyncOperation.h"

@interface AQAquaSyncPushSyncOperation ()

@property (nonatomic, assign) BOOL isFinished;

//{@dependencies
/**
 *  An AquaSync client dependency property for easier testing.
 *  Typically, it should be retained by `AQAquaSyncService` class.
 */
@property (nonatomic, weak) AQAquaSyncClient *client;
//}

@end

@implementation AQAquaSyncPushSyncOperation

- (instancetype)initWithDelegate:(id<AQAquaSyncPushSyncOperationDelegate>)delegate
              withAquaSyncClient:(AQAquaSyncClient *)client {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.client = client;
    }
    return self;
}

# pragma mark - NSOperation

- (BOOL)isConcurrent {
    return YES;
}

@end
