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
    [RLMRealm useInMemoryDefaultRealm];
    
    AQModel *model = [[AQModel alloc] init];
    [model save];
    AQModel *model2 = [[AQModel alloc] init];
    [model2 save];
    NSLog(@"%@", [model aq_toDictionary]);
    
    RLMArray *r = [AQModel objectsWhere:@"isDirty = true"];
    NSLog(@"%@", [r aq_toDictionaryArray]);
    
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
