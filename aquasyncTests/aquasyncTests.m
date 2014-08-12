#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "AQSyncManager.h"
#import "AQUtil.h"

#import "AQJSONAdapter.h"
#import "Dog.h"

#import "AQModel.h"

SpecBegin(AQModel)

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
                                          @"age": @"10"
                                          };
                Dog *dog = [AQJSONAdapter serializeFromJSONDictionary:dogJSON withClass:[Dog class]];
                expect(dog.dogName).to.equal(@"pochi");
            });
            
            it(@"should serialize a String", ^{
                NSDictionary *dogJSON = @{
                                          @"dog_name": @"pochi",
                                          @"age": @"10"
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