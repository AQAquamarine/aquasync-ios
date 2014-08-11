#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

SpecBegin(AQModel)

describe(@"AQModel", ^{
    it(@"specta is runnnig!", ^{
        expect(@"specta").to.equal(@"specta");
    });
    
    it(@"specta is specta", ^{
        expect(@"foo").to.equal(@"foo");
    });
});

SpecEnd