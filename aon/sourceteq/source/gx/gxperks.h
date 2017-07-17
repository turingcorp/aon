typedef enum
{
    perktypelife,
    perktypebigball,
    perktypebigbar,
    perktypeclock,
    perktypestarball,
    perktypestarheart,
    perktypenone
}perktype;

#import "appdel.h"

@class ctrgame;
@class gxperk;

@interface gxperks:NSObject<ctrdrawerdel>

-(gxperks*)init:(ctrgame*)_game;
-(void)add:(gxperk*)_perk;
-(void)repos;
-(void)tick;

@property(weak, nonatomic)ctrgame *game;

@end

@interface gxperk:NSObject<ctrdrawerdel>

-(gxperk*)init:(perktype)_type posx:(CGFloat)_posx posy:(CGFloat)_posy;
-(void)repos;

@property(nonatomic)perktype type;
@property(nonatomic)CGFloat posx;
@property(nonatomic)CGFloat posy;
@property(nonatomic)CGFloat size;
@property(nonatomic)CGFloat midsize;
@property(nonatomic)CGFloat speedy;
@property(nonatomic)NSInteger ttl;
@property(nonatomic)BOOL taken;

@end