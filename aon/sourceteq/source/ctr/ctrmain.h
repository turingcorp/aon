#import "appdel.h"

@class ctrgame;
@class ctrdrawer;
@class vihub;

@interface ctrmain:GLKViewController<UIGestureRecognizerDelegate>

+(ctrmain*)sha;

@property(strong, nonatomic)ctrgame *game;
@property(strong, nonatomic)ctrdrawer *drawer;
@property(weak, nonatomic)vihub *hub;

@end