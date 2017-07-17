#import "appdel.h"
#import "gxperks.h"

@class ctrgame;

@interface gxbricks:NSObject<ctrdrawerdel, gxballbouncer>

-(gxbricks*)init:(ctrgame*)_game;
-(void)tick;
-(void)movebricks;
-(void)gohalfspeed;
-(void)diedhalfspeed;

@property(weak, nonatomic)ctrgame *game;

@end

@interface gxbrick:NSObject<ctrdrawerdel>

-(gxbrick*)init:(CGFloat)_xpos ypos:(CGFloat)_ypos xspeed:(CGFloat)_xspeed yspeed:(CGFloat)_yspeed midwidth:(CGFloat)_midwidth level:(NSInteger)_level perkratio:(NSInteger)_perkratio;
-(void)redimmension;
-(void)godown;

@property(nonatomic)GLKVector4 color;
@property(nonatomic)CGFloat xpos;
@property(nonatomic)CGFloat ypos;
@property(nonatomic)CGFloat xspeed;
@property(nonatomic)CGFloat yspeed;
@property(nonatomic)CGFloat xspeed_half;
@property(nonatomic)CGFloat yspeed_half;
@property(nonatomic)CGFloat midwidth;
@property(nonatomic)NSInteger orlevel;
@property(nonatomic)NSInteger level;
@property(nonatomic)perktype perky;

@end