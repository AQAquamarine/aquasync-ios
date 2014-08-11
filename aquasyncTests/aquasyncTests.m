#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

SpecBegin(AQModel)

describe(@"AQModel", ^{
    describe(@"beforeCreate", ^{
        it(@"localTimestamp it set", ^{
            expect(@"AQModel").to.equal(@"AQModel");
        });
    });
    
    it(@"specta is specta", ^{
        expect(@"foo").to.equal(@"foo");
    });
});

SpecEnd