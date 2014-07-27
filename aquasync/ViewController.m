//
//  ViewController.m
//  aquasync
//
//  Created by kaiinui on 2014/07/27.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "ViewController.h"
#import "Aquasync.h"

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AQSyncManager *manager = [AQSyncManager sharedInstance];
    [manager.models setObject:[AQModel class] forKey:@"somemodel"];
    NSDictionary *dic = [manager getDeltas];
    NSLog(@"%@", dic);
    
    [AQDeltaClient sharedInstance].baseURI = @"https://BASE_URI/";
    [[AQDeltaClient sharedInstance] pullDeltas:2344];
    [[AQDeltaClient sharedInstance] pushDeltas:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
