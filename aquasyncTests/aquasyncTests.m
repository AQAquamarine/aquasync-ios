#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import <ObjectiveRecord.h>

#import "Album.h"
#import "AQUtil.h"

@interface Album ()
+ (NSDictionary *)helper_inverseDictionary:(NSDictionary *)dictionary;
@end

SpecBegin(Album)

describe(@"Album", ^{
    [CoreDataManager sharedManager].modelName = @"aquasync";
    
    NSString *deviceToken = [AQUtil getDeviceToken];
    
    describe(@"Serialization", ^{
        Album *model = [Album create];
        NSDictionary *dictionary = @{
                                     @"title": @"Harry Potter"
                                     };
        it(@"should return merged JSONKeyMap", ^{
            expect([Album JSONKeyMap]).to.equal(@{
                                                  @"aq_gid": @"gid",
                                                  @"aq_deviceToken": @"deviceToken",
                                                  @"aq_localTimestamp": @"localTimestamp",
                                                  @"aq_isDeleted": @"isDeleted",
                                                  @"aq_isDirty": @"isDirty",
                                                  @"title": @"title"
                                                  });
        });
        
        it(@"should set title from dictionary", ^{
            [model setValuesWithDictionary:dictionary];
            expect(model.title).to.equal(@"Harry Potter");
        });
    });
    
    describe(@"-aq_all", ^{
        Album *model = [Album create];
        NSString *gid = model.aq_gid;
        [model aq_save];
        
        it(@"should find undeleted records", ^{
            expect([Album aq_all].count).to.beGreaterThan(1);
        });
    });
    
    describe(@"-aq_where:query;", ^{
        it(@"should find undeleted records", ^{
            Album *model = [Album create];
            NSString *gid = model.aq_gid;
            [model aq_save];
            NSString *query = [NSString stringWithFormat:@"aq_gid == '%@'", gid];
            expect([Album aq_where:query].count).to.equal(1);
        });
        
        it(@"should not find deleted records", ^{
            Album *deleted = [Album create];
            deleted.aq_isDeleted = YES;
            NSString *deletedGid = deleted.aq_gid;
            [deleted aq_save];
            NSString *query = [NSString stringWithFormat:@"aq_gid == '%@'", deletedGid];
            expect([Album aq_where:query].count).to.equal(0);
        });
    });
    
    describe(@"-aq_destroy", ^{
        it(@"should destroy the object", ^{
            Album *model = [Album create];
            [model aq_destroy];
            expect(model.aq_isDeleted).to.equal(YES);
        });
    });
    
    describe(@"-aq_find:gid;", ^{
        it(@"should find object with gid", ^{
            Album *model = [Album create];
            NSString *gid = model.aq_gid;
            [model aq_save];
            expect([Album aq_find:gid].aq_gid).to.equal(gid);
        });
        
        it(@"should return nil if not found", ^{
            expect([Album aq_find:@"8s7f78sdjas"]).to.beNil;
        });
    });
    
    describe(@"-init;", ^{
        Album *model = [Album create];
        
        it(@"should set valid gid", ^{
            expect(model.aq_gid).to.beTruthy;
        });
        it(@"should not be deleted", ^{
            expect(model.aq_isDeleted).to.equal(NO);
        });
        it(@"should set valid deviceToken", ^{
            expect(model.aq_deviceToken).to.equal(deviceToken);
        });
    });
    
    describe(@"-save;", ^{
        [[CoreDataManager sharedManager] useInMemoryStore];
        Album *model = [Album create];
        [model aq_save];
        
        it(@"persists the data", ^{
            expect([Album all].count).to.beGreaterThanOrEqualTo(1);
        });
        it(@"should set localTimestamp", ^{
            expect(model.aq_localTimestamp).to.beTruthy;
        });
        it(@"should be dirty", ^{
            expect(model.aq_isDirty).to.equal(YES);
        });
    });
    
    describe(@"+helper_inverseDictionary", ^{
        it(@"should inverse key and value", ^{
            NSDictionary *dictionary = @{
                                         @"key": @"value",
                                         @"someKey": @"someValue"
                                         };
            expect([Album helper_inverseDictionary:dictionary][@"value"]).to.equal(@"key");
            expect([Album helper_inverseDictionary:dictionary][@"someValue"]).to.equal(@"someKey");
        });
    });
});

SpecEnd


/*
SpecBegin(AQModel)

describe(@"AQAquasyncModelRequirement", ^{
    beforeEach(^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects: [AQModel allObjects]];
        [realm commitWriteTransaction];
    });
    
    describe(@"-aq_resolveConflict:delta;", ^{
        NSDictionary *delta = @{
                                @"gid": @"aaaaaaaa-e29b-41d4-a716-446655dd0000",
                                @"localTimestamp": @2000000000,
                                @"deviceToken": [AQUtil getDeviceToken],
                                @"isDeleted": @NO
                                };
        it(@"should update from delta", ^{
            AQModel *model = [[AQModel alloc] init];
            model.gid = @"aaaaaaaa-e29b-41d4-a716-446655dd0000";
            [model save];
            [model aq_resolveConflict:delta];
            expect(model.localTimestamp).to.equal(2000000000);
        });
        
        it(@"updated record should not be dirty", ^{
            AQModel *model = [[AQModel alloc] init];
            model.gid = @"aaaaaaaa-e29b-41d4-a716-446655dd0000";
            [model save];
            [model undirty];
            [model aq_resolveConflict:delta];
            expect(model.isDirty).to.equal(false);
        });
    });
});

describe(@"AQAquasyncModelManagerMethods", ^{
    beforeEach(^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects: [AQModel allObjects]];
        [realm commitWriteTransaction];
    });
    
    describe(@"+aq_extractDeltas;", ^{
        it(@"should extract 3 deltas", ^{
            AQModel *model1 = [[AQModel alloc] initWithCallBack];
            [model1 save];
            
            AQModel *model2 = [[AQModel alloc] initWithCallBack];
            [model2 save];
            
            AQModel *model3 = [[AQModel alloc] initWithCallBack];
            [model3 save];
            expect([AQModel dirtyRecords].count).to.equal(3);
        });
    });
    
    describe(@"+aq_receiveDeltas", ^{
        context(@"all delta is new", ^{
            NSArray *deltas = @[
                                @{
                                    @"gid": @"aaaaaaaa-e29b-41d4-a716-446655dd0000",
                                    @"localTimestamp": @1000000000,
                                    @"deviceToken": [AQUtil getDeviceToken],
                                    @"isDeleted": @NO
                                    },
                                @{
                                    @"gid": @"bbbbbbbb-e29b-41d4-a716-446655dd0000",
                                    @"localTimestamp": @1000000000,
                                    @"deviceToken": [AQUtil getDeviceToken],
                                    @"isDeleted": @NO
                                    },
                                ];
            
            it(@"should receive deltas", ^{
                [AQModel aq_receiveDeltas:deltas];
                expect([AQModel allObjects].count).to.equal(2);
            });
            
            it(@"a record which is created when merged should not be dirty", ^{
                [AQModel aq_receiveDeltas:deltas];
                AQModel *model = [AQModel allObjects].firstObject;
                expect(model.isDirty).to.equal(false);
            });
        });
        
        context(@"1 delta is known and 1 is new", ^{
            context(@"known delta is newer in localTimetamp than local one", ^{
                NSArray *deltas = @[
                                    @{
                                        @"gid": @"aaaaaaaa-e29b-41d4-a716-446655dd0000",
                                        @"localTimestamp": @2000000000,
                                        @"deviceToken": [AQUtil getDeviceToken],
                                        @"isDeleted": @NO
                                        },
                                    @{
                                        @"gid": @"bbbbbbbb-e29b-41d4-a716-446655dd0000",
                                        @"localTimestamp": @1000000000,
                                        @"deviceToken": [AQUtil getDeviceToken],
                                        @"isDeleted": @NO
                                        },
                                    ];
                it(@"should update from delta", ^{
                    AQModel *model = [[AQModel alloc] init];
                    model.gid = @"aaaaaaaa-e29b-41d4-a716-446655dd0000";
                    [model save];
                    [AQModel aq_receiveDeltas:deltas];
                    expect([AQModel allObjects].count).to.equal(2);
                    expect([AQModel find:@"aaaaaaaa-e29b-41d4-a716-446655dd0000"].localTimestamp).to.equal(2000000000);
                });
            });
        });
    });
    
    describe(@"+aq_undirtyRecordsFromDeltas:deltas;", ^{
        NSArray *deltas = @[
                            @{
                                @"gid": @"aaaaaaaa-e29b-41d4-a716-446655dd0000",
                                @"localTimestamp": @2000000000,
                                @"deviceToken": [AQUtil getDeviceToken],
                                @"isDeleted": @NO
                                },
                            @{
                                @"gid": @"bbbbbbbb-e29b-41d4-a716-446655dd0000",
                                @"localTimestamp": @1000000000,
                                @"deviceToken": [AQUtil getDeviceToken],
                                @"isDeleted": @NO
                                },
                            ];
        it(@"should undirty records", ^{
            AQModel *model = [[AQModel alloc] init];
            model.gid = @"aaaaaaaa-e29b-41d4-a716-446655dd0000";
            [model save];
            
            AQModel *model2 = [[AQModel alloc] init];
            model2.gid = @"bbbbbbbb-e29b-41d4-a716-446655dd0000";
            [model2 save];
            
            [AQModel aq_undirtyRecordsFromDeltas:deltas];
            AQModel *record = [AQModel find:@"bbbbbbbb-e29b-41d4-a716-446655dd0000"];
            expect(record.isDirty).to.equal(false);
            expect([AQModel dirtyRecords].count).to.equal(0);
        });
    });
});

describe(@"AQModel", ^{
    beforeEach(^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObjects: [AQModel allObjects]];
        [realm commitWriteTransaction];
    });
    
    describe(@"callback methods", ^{
        context(@"when model is created", ^{
            it(@"should not be deleted when created", ^{
                AQModel *model = [[AQModel alloc] initWithCallBack];
                expect(model.isDeleted).to.equal(false);
            });
            
            it(@"should set deviceToken when created", ^{
                AQModel *model = [[AQModel alloc] initWithCallBack];
                expect(model.deviceToken).to.beTruthy;
            });
            
            it(@"should set gid when created", ^{
                AQModel *model = [[AQModel alloc] initWithCallBack];
                expect(model.gid).to.beTruthy;
            });
        });
        
        context(@"before saved", ^{
            it(@"should set localTimestamp when save.", ^{
                AQModel *model = [[AQModel alloc] initWithCallBack];
                [model save];
                expect(model.localTimestamp).to.beInTheRangeOf(1000000000, INT_MAX);
            });
            
            it(@"should be dirty when save", ^{
                AQModel *model = [[AQModel alloc] initWithCallBack];
                [model save];
                expect(model.isDirty).to.equal(true);
            });
        });
    });
    
    describe(@"logical deletion", ^{
        it(@"should not be found by +all; after deleted", ^{
            AQModel *model = [[AQModel alloc] initWithCallBack];
            [model save];
            [model destroy];
            expect([AQModel all].count).to.equal(0);
        });
    });
    
    describe(@"serialization", ^{
        context(@"-aq_toDictionary;", ^{
            AQModel *model = [[AQModel alloc] initWithCallBack];
            [model save];
            NSDictionary *dic = [model aq_toDictionary];
            
            it(@"should not contain isDirty", ^{
                expect(dic).notTo.contain(@"isDirty");
            });
            
            it(@"should contain localTimestamp", ^{
                expect(dic).to.contain(@"localTimestamp");
            });
            
            it(@"should contain isDeleted", ^{
                expect(dic).to.contain(@"isDeleted");
            });
            
            it(@"should contain deviceToken", ^{
                expect(dic).to.contain(@"deviceToken");
            });
        });
        
        context(@"-aq_updateFromDictionary:dictionary;", ^{
            NSDictionary *dic = @{
                                  @"isDeleted": @NO,
                                  @"localTimestamp": @1489978777,
                                  @"deviceToken": @"550e8400-e29b-41d4-a716-446655dd0000"                                  };
            AQModel *model = [[AQModel alloc] initWithCallBack];
            [model aq_updateFromDictionary:dic];
            
            it(@"isDeleted should updated", ^{
                expect(model.isDeleted).to.equal(false);
            });
            
            it(@"localTimestamp should updated", ^{
                expect(model.localTimestamp).to.equal(1489978777);
            });
            
            it(@"deviceToken should updated", ^{
                expect(model.deviceToken).to.equal(@"550e8400-e29b-41d4-a716-446655dd0000");
            });
        });
    });
});

SpecEnd

SpecBegin(AQJSONAdapter)

describe(@"AQJSONAdapter", ^{
    describe(@"-serializeToJSONDictionary:obj;", ^{
        context(@"serialize a dog to dictionary", ^{
            it(@"should serialize a String", ^{
                Dog *dog = [Dog new];
                dog.dogName = @"pochi";
                expect([AQJSONAdapter serializeToJSONDictionary:dog][@"dog_name"]).to.equal(@"pochi");
            });
            
            it(@"should serialize an Int", ^{
                Dog *dog = [Dog new];
                dog.age = 10;
                expect([AQJSONAdapter serializeToJSONDictionary:dog][@"age"]).to.equal(10);
            });
        });
    });
    
    describe(@"-serializeFromJSONDictionary:json:withClass;", ^{
        context(@"serialize a dictionary to a dog", ^{
            it(@"should serialize a String", ^{
                NSDictionary *dogJSON = @{
                                          @"dog_name": @"pochi",
                                          @"age": @10
                                          };
                Dog *dog = [AQJSONAdapter serializeFromJSONDictionary:dogJSON withClass:[Dog class]];
                expect(dog.dogName).to.equal(@"pochi");
            });
            
            it(@"should serialize a String", ^{
                NSDictionary *dogJSON = @{
                                          @"dog_name": @"pochi",
                                          @"age": @10
                                          };
                Dog *dog = [AQJSONAdapter serializeFromJSONDictionary:dogJSON withClass:[Dog class]];
                expect(dog.age).to.equal(10);
            });
        });
    });
});

SpecEnd

SpecBegin(AQSyncManager)

describe(@"AQSyncManager", ^{
    describe(@"registModelManager", ^{
        it(@"should add Class object to its models", ^{
            [[AQSyncManager sharedInstance] registModelManager:[NSString class] forName:@"NSObject"];
            NSLog(@"%@", [[AQSyncManager sharedInstance] models]);
            expect([[AQSyncManager sharedInstance] models]).to.haveCountOf(1);
        });
    });
});

describe(@"AQUtil", ^{
    it(@"getCurrentTimestamp returns timestamp value", ^{
        expect([AQUtil getCurrentTimestamp]).to.beInTheRangeOf(1000000000, INT_MAX);
    });
    
    it(@"getUUID returns string", ^{
        expect([AQUtil getUUID]).to.beTruthy;
    });
    
    it(@"getDeviceToken returns string", ^{
        expect([AQUtil getDeviceToken]).to.beTruthy;
    });
    
    it(@"joinString:and; joins string", ^{
        expect([AQUtil joinString:@"foo" and:@"bar"]).to.equal(@"foobar");
    });
    
    it(@"parseInt parses int to string properly", ^{
        expect([AQUtil parseInt:100]).to.equal(@"100");
    });
});

SpecEnd

*/