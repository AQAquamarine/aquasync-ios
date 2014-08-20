#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ObjectiveRecord.h>
#import "SerializableManagedObject.h"

@interface AquasyncModel : SerializableManagedObject

@property (nonatomic, retain) NSString * aq_gid;
@property (nonatomic, retain) NSString * aq_deviceToken;
@property (nonatomic, retain) NSNumber * aq_localTimestamp;
@property (nonatomic, assign) BOOL aq_isDirty;
@property (nonatomic, assign) BOOL aq_isDeleted;

- (void)beforeSave;
- (void)aq_save;

+ (NSArray *)aq_all;
+ (NSArray *)aq_where:(NSString *)query;

+ (NSDictionary *)JSONKeyMapWithDictionary:(NSDictionary *)dictionary;

@end
