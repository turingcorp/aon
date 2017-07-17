#import "appdel.h"

@interface modachs:NSObject

+(modachs*)sha;
-(NSArray*)achievementsids:(NSInteger)_score;

@end

@interface modach:NSObject

-(modach*)init:(NSString*)_achid points:(NSNumber*)_points;

@property(strong, nonatomic)NSString *achid;
@property(nonatomic)NSInteger points;

@end