//
//  ViewController.m
//  aquasync
//
//  Created by kaiinui on 2014/07/27.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "ViewController.h"
#import "Aquasync.h"
#import "FLMAlbum.h"

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [AQUtil getDeviceToken]);
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects: [FLMAlbum allObjects]];
    [realm commitWriteTransaction];
    
    FLMAlbum *album1 = [FLMAlbum new];
    [album1 save];
    
    FLMAlbum *album2 = [[FLMAlbum alloc] init];
    [album2 save];
    
    [AQDeltaClient sharedInstance].baseURI = @"http://0.0.0.0:3000/api/v1/";
    [[AQDeltaClient sharedInstance] setBasicAuthorizationWithUsername:@"hogehoge" password:@"hogehoge"];
    AQSyncManager *manager = [AQSyncManager sharedInstance];
    [manager registModelManager:[FLMAlbum class] forName:@"Album"];
    //[manager sync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
