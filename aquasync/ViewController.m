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
    RLMMigrationBlock migrationBlock = ^NSUInteger(RLMMigration *migration,
                                                   NSUInteger oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // Nothing to do!
            // Realm will automatically detect new properties and removed properties
            // And will update the schema on disk automatically
        }
        // Return the latest version number (always set manually)
        // Must be a higher than the previous version or an RLMException is thrown
        return 1;
    };
    
    // Apply the migration block above to the default Realm
    [RLMRealm migrateDefaultRealmWithBlock:migrationBlock];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects: [FLMAlbum allObjects]];
    [realm commitWriteTransaction];
    
    FLMAlbum *album1 = [FLMAlbum new];
    [album1 beforeCreate];
    album1.title = @"hge";
    [album1 save];
    
    FLMAlbum *album2 = [[FLMAlbum alloc] init];
    [album2 beforeCreate];
    album2.title = @"title2sr";
    [album2 save];
    
    NSLog(@"%@", album1.title);
    NSLog(@"%@", [FLMAlbum allObjects]);
    
    [AQDeltaClient sharedInstance].baseURI = @"http://0.0.0.0:7999/api/v1/";
    [[AQDeltaClient sharedInstance] setBasicAuthorizationWithUsername:@"hogehoge" password:@"hogehoge"];
    AQSyncManager *manager = [AQSyncManager sharedInstance];
    [manager registModelManager:[FLMAlbum class] forName:@"Album"];
    [manager sync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
