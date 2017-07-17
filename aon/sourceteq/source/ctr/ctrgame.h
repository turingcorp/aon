#import "appdel.h"

typedef enum
{
    gamestatenotstarted,
    gamestatenormal,
    gamestatefinished
}gamestate;

@class gxball;
@class gxbar;
@class gxbricks;
@class gxhearts;
@class gxeffects;
@class gxbrick;
@class gxheart;
@class gxperks;
@class gxperk;

@interface ctrgame:NSObject<timerbgdel>

-(void)desiredposition:(CGFloat)_x;
-(void)startgame;
-(void)resumegame;
-(void)pausegame;
-(void)restartgame;
-(void)render;
-(void)unbricked:(gxbrick*)_brick gain:(BOOL)_gain;
-(void)pumping;
-(void)unheart:(gxheart*)_heart;
-(void)perkontheloose:(gxperk*)_perk;
-(void)perkexpired:(gxperk*)_perk;
-(void)endgame;

@property(strong, nonatomic)gxball *ball;
@property(strong, nonatomic)gxbar *bar;
@property(strong, nonatomic)gxbricks *bricks;
@property(strong, nonatomic)gxhearts *hearts;
@property(strong, nonatomic)gxeffects *effects;
@property(strong, nonatomic)gxperks *perks;
@property(nonatomic)gamestate state;
@property(nonatomic)NSInteger score;

@end