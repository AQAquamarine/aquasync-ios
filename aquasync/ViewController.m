//
//  ViewController.m
//  aquasync
//
//  Created by kaiinui on 2014/07/27.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "ViewController.h"
#import "Aquasync.h"
#import "Album.h"

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self check];
    
    Album *album = [Album create];
    [album save];
}

- (void)check {
    [AQDeltaClient sharedInstance].baseURI = @"http://0.0.0.0:7999/api/v1/";
    [[AQDeltaClient sharedInstance] setBasicAuthorizationWithUsername:@"hogehoge" password:@"hogehoge"];
    AQSyncManager *manager = [AQSyncManager sharedInstance];
    [manager registModelManager:[Album class] forName:@"Album"];
    [manager sync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
