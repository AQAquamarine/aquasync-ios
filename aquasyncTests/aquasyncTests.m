#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "AQSyncManager.h"
#import "AQUtil.h"

SpecBegin(AQModel)

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