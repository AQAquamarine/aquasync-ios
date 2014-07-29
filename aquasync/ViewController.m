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
    
    AQModel *model = [[AQModel alloc] init];
    NSLog(@"%hhd", model.isDeleted);
    NSLog(@"%@", model.deviceToken);
    NSLog(@"%@", model.gid);
    NSLog(@"%ld", model.localTimestamp);
    NSLog(@"%hhd", model.isDirty);
    [model save];
    
    RLMArray *r = [AQModel objectsWhere:@"localTimestamp < 8"];
    NSLog(@"%@", r);
    
    [AQDeltaClient sharedInstance].baseURI = @"http://0.0.0.0:4567/";
    AQSyncManager *manager = [AQSyncManager sharedInstance];
    [manager registModelManager:[AQModel class] forName:@"model1"];
    [manager registModelManager:[AQModel class] forName:@"model2"];
    [manager sync];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
