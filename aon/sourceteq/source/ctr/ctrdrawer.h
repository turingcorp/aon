#import "appdel.h"

@class ctrgame;
@class gxball;
@class gxbar;
@class gxbricks;
@class gxhearts;
@class gxeffects;
@class gxperks;

@interface ctrdrawer:NSObject<GLKViewDelegate>

-(ctrdrawer*)init:(ctrgame*)_game;
-(void)newgame:(ctrgame*)_game;

@property(weak, nonatomic)gxball *ball;
@property(weak, nonatomic)gxbar *bar;
@property(weak, nonatomic)gxbricks *bricks;
@property(weak, nonatomic)gxhearts *hearts;
@property(weak, nonatomic)gxeffects *effects;
@property(weak, nonatomic)gxperks *perks;

@end