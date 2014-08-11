#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "AQSyncManager.h"
#import "AQUtil.h"

#import "AQJSONAdapter.h"
#import "Dog.h"

SpecBegin(AQJSONAdapter)

describe(@"AQJSONAdapter", ^{
    describe(@"-serializeToJSONDictionary", ^{
        it(@"serialize a dog to dictionary", ^{
            Dog *dog = [Dog new];
            dog.dogName = @"pochi";
            expect([AQJSONAdapter serializeToJSONDictionary:dog][@"dog_name"]).to.equal(@"pochi");
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