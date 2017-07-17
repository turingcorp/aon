#import "appdel.h"

@interface gkman:NSObject<GKGameCenterControllerDelegate>

+(gkman*)sha;
-(void)login;
-(void)showleaders;
-(void)newscore:(NSInteger)_score;

@end