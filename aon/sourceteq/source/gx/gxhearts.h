#import "appdel.h"

@class ctrgame;
@class gxbrick;

@interface gxhearts:NSObject<ctrdrawerdel, gxballbouncer>

-(gxhearts*)init:(ctrgame*)_game;
-(BOOL)breakme:(gxbrick*)_brick;
-(void)addheart;
-(void)gostar;
-(void)diedstar;

@property(weak, nonatomic)ctrgame *game;

@end

@interface gxheart:NSObject<ctrdrawerdel>

-(gxheart*)init:(CGFloat)_xpos ypos:(CGFloat)_ypos midwidth:(CGFloat)_midwidth midheight:(CGFloat)_midheight index:(NSInteger)_index;

@property(nonatomic)CGFloat xpos;
@property(nonatomic)CGFloat ypos;
@property(nonatomic)NSInteger index;

@end