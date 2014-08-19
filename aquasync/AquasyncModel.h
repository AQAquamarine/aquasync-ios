#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <ObjectiveRecord.h>

@interface AquasyncModel : NSManagedObject

@property (nonatomic, retain) NSString * gid;
@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSNumber * localTimestamp;
@property (nonatomic, assign) BOOL dirty;
@property (nonatomic, assign) BOOL deleted;

@end
