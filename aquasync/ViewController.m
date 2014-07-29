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
    
    NSLog(@"%ld", [AQUtil getCurrentTimestamp]);
    
    [AQDeltaClient sharedInstance].baseURI = @"http://0.0.0.0:4567/";
    AQSyncManager *manager = [AQSyncManager sharedInstance];
    [manager registModelManager:[AQModel class] forName:@"model1"];
    [manager sync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
