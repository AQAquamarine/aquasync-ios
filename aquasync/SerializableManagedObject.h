#import <CoreData/CoreData.h>

@interface SerializableManagedObject : NSManagedObject

- (void)setValuesWithDictionary:(NSDictionary *)dictionary;

// Inherited classes should implement these methods.
+ (NSDictionary *)JSONKeyMap;
+ (NSDictionary *)JSONValueTransformerNames;

@end
