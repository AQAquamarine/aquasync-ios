#import <CoreData/CoreData.h>

@interface SerializableManagedObject : NSManagedObject

- (void)setValuesWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)JSONKeyMap;
+ (NSDictionary *)JSONValueTransformerNames;

@end
