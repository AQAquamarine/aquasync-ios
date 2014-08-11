#import "Dog.h"

@implementation Dog

@synthesize dogName;

+ (NSDictionary *)keyMap {
    return @{
             @"dogName": @"dog_name"
             };
}

@end
