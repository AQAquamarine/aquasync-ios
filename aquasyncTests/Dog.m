#import "Dog.h"

@implementation Dog

@synthesize dogName, age;

+ (NSDictionary *)keyMap {
    return @{
             @"dogName": @"dog_name",
             @"age": @"age"
             };
}

@end
