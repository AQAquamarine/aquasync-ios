#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ObjectiveRecord.h>
#import "SerializableManagedObject.h"
#import "AQAquasyncModelProtocol.h"
#import "AQModelManagerProtocol.h"

@interface AquasyncModel : SerializableManagedObject <AQAquasyncModelProtocol, AQModelManagerProtocol>

@property (nonatomic, retain) NSString * aq_gid;
@property (nonatomic, retain) NSString * aq_deviceToken;
@property (nonatomic, retain) NSNumber * aq_localTimestamp;
@property (nonatomic, assign) BOOL aq_isDirty;
@property (nonatomic, assign) BOOL aq_isDeleted;

# pragma mark - Create

+ (instancetype)aq_create;

# pragma mark - AQAquasyncModelProtocol

- (void)aq_resolveConflict:(NSDictionary *)delta;

# pragma mark - AQModelManagerProtocol

+ (NSArray *)aq_extractDeltas;
+ (void)aq_receiveDeltas:(NSArray *)deltas;
+ (void)aq_undirtyRecordsFromDeltas:(NSArray *)deltas;

# pragma mark - ActiveRecord Interfaces

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

# pragma mark - AquasyncModelManager Helpers

- (void)aq_undirty;
+ (NSArray *)aq_dirtyRecords;

# pragma mark - Callback Methods

// Should be called before being saved.
// It will
//   1. Make the object dirty.
//   2. Set localTimestamp.
- (void)beforeSave;

# pragma mark - SerializableManagedObject

// Merges given dictionary JSONKeyMap and AquasyncModel JSONKeyMap and then return it.
// @param dictionary JSONKeyMap (with is used by SerializableManagedObject)
// @return JSONKeyMap
+ (NSDictionary *)JSONKeyMapWithDictionary:(NSDictionary *)dictionary;

@end
