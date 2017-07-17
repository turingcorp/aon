#import "appdel.h"

@interface gxball:NSObject<ctrdrawerdel>

-(gxball*)init:(CGFloat)_xpos ypos:(CGFloat)_ypos;
-(void)centerx:(CGFloat)_newx y:(CGFloat)_newy;
-(void)bounce;
-(void)gobig;
-(void)gosmall;
-(void)gostart;
-(void)diedbig;
-(void)diedsmall;
-(void)diedstar;

@property(nonatomic)CGFloat xpos;
@property(nonatomic)CGFloat ypos;
@property(nonatomic)CGFloat radius;
@property(nonatomic)CGFloat maxspeed;
@property(nonatomic)CGFloat minspeed;
@property(nonatomic)CGFloat xspeed;
@property(nonatomic)CGFloat yspeed;
@property(nonatomic)NSInteger starcounter;

@end