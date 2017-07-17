#import "appdel.h"

@interface tools:NSObject

+(tools*)sha;
-(BOOL)string:(NSString*)_string contains:(NSString*)_other;
-(NSNumber*)now;
-(NSString*)scoretostring:(NSInteger)_score;

@end