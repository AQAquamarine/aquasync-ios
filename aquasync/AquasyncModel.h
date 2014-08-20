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
- (void)aq_destroy;

+ (NSArray *)aq_all;
+ (NSArray *)aq_where:(NSString *)query;
+ (instancetype)aq_find:(NSString *)gid;

+ (NSDictionary *)JSONKeyMapWithDictionary:(NSDictionary *)dictionary;

@end
