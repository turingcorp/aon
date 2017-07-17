#import "appdel.h"

typedef enum
{
    effecttypecrash,
    effecttypeunbrick,
    effecttypepumper,
    effecttypeunheart,
    effecttypestarter
}effecttype;

@class gxeffect;

@interface gxeffects:NSObject<ctrdrawerdel>

-(void)add:(gxeffect*)_effect;
-(void)tick;

@end

@interface gxeffect:NSObject<ctrdrawerdel>

-(gxeffect*)init:(effecttype)_type posx:(CGFloat)_posx posy:(CGFloat)_posy;

@property(nonatomic)effecttype type;
@property(nonatomic)CGFloat posx;
@property(nonatomic)CGFloat posy;
@property(nonatomic)CGFloat size;
@property(nonatomic)NSInteger ttl;

@end