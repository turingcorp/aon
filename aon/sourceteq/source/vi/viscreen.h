#import "appdel.h"

@interface viscreen:UIView

+(void)show;

@property(weak, nonatomic)UIButton *btnnewgame;
@property(weak, nonatomic)UIButton *btnresume;
@property(weak, nonatomic)UIButton *btnrestart;
@property(weak, nonatomic)UIButton *btninstructions;
@property(weak, nonatomic)UIButton *btnscores;
@property(weak, nonatomic)UIButton *btnstore;
@property(weak, nonatomic)UIImageView *logo;
@property(weak, nonatomic)UILabel *lblcurrent;
@property(weak, nonatomic)UILabel *lblscore;
@property(weak, nonatomic)UILabel *lbldied;

@end