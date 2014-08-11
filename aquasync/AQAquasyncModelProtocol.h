#import <Foundation/Foundation.h>

@protocol AQAquasyncModelProtocol <NSObject>

@required

@property (nonatomic, retain) NSString *gid;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, assign) long localTimestamp;
@property (nonatomic, assign) BOOL isDirty;
@property (nonatomic, assign) BOOL isDeleted;

@end
