#import "appdel.h"

@class ctrgame;

@interface gxbar:NSObject<ctrdrawerdel, gxballbouncer>

-(gxbar*)init:(ctrgame*)_game xpos:(CGFloat)_xpos ypos:(CGFloat)_ypos;
-(void)centerx:(CGFloat)_newx y:(CGFloat)_newy;
-(void)gobig;
-(void)gosmall;
-(void)diedbig;
-(void)diedsmall;

@property(weak, nonatomic)ctrgame *game;
@property(nonatomic)CGFloat xpos;
@property(nonatomic)CGFloat ypos;
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat height;
@property(nonatomic)CGFloat width_2;
@property(nonatomic)CGFloat height_2;
@property(nonatomic)CGFloat speed;
@property(nonatomic)CGFloat xspeed;
@property(nonatomic)CGFloat desiredxpos;

@end