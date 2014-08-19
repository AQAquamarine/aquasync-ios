#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ObjectiveRecord.h>

@interface AquasyncModel : NSManagedObject

@property (nonatomic, retain) NSString * aq_gid;
@property (nonatomic, retain) NSString * aq_deviceToken;
@property (nonatomic, retain) NSNumber * aq_localTimestamp;
@property (nonatomic, assign) BOOL aq_isDirty;
@property (nonatomic, assign) BOOL aq_isDeleted;

- (void)beforeSave;
- (void)aq_save;

@end
