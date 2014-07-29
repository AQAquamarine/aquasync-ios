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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1234234 forKey:kAQLatestUSTKey];
    
    AQSyncManager *manager = [AQSyncManager sharedInstance];
    [manager registModelManager:[AQModel class] forName:@"model1"];
    [manager registModelManager:[AQModel class] forName:@"model2"];
    NSDictionary *dic = [manager getDeltas];
    NSLog(@"%@", dic);
    
    [AQDeltaClient sharedInstance].baseURI = @"http://0.0.0.0:4567/";
    [[AQDeltaClient sharedInstance] pullDeltas:2344];
    [[AQDeltaClient sharedInstance] pushDeltas:nil];
    
    [[AQSyncManager sharedInstance] sync];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
