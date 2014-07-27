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
    
    int timeStamp = [AQUtil getCurrentTimestamp];
    NSLog(@"%d", timeStamp);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
