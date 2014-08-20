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

// Returns found records.
// @param query should be like @"album_id == 2 AND title == 'Hawaii'"
// @return the found records.
+ (NSArray *)aq_where:(NSString *)query;

// Finds record with given gid.
// @return @Nullable the found record or nil if not found.
+ (instancetype)aq_find:(NSString *)gid;

// Merges given dictionary JSONKeyMap and AquasyncModel JSONKeyMap and then return it.
// @param dictionary JSONKeyMap (with is used by SerializableManagedObject)
// @return JSONKeyMap
+ (NSDictionary *)JSONKeyMapWithDictionary:(NSDictionary *)dictionary;

@end
