#import "AQModel.h"

#import "AquasyncModelExtensions.h"

@interface FLMAlbum : RLMObject <AQAquasyncModelProtocol>

@property (nonatomic, retain) NSString *title;

- (instancetype)init;

@end
