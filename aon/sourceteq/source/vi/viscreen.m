#import "viscreen.h"

@implementation viscreen

@synthesize btnnewgame;
@synthesize btnresume;
@synthesize btnrestart;
@synthesize btninstructions;
@synthesize btnscores;
@synthesize btnstore;
@synthesize logo;
@synthesize lblcurrent;
@synthesize lblscore;
@synthesize lbldied;

+(void)show
{
    viscreen *screen = [[viscreen alloc] init];
    [[ctrmain sha].view addSubview:screen];
    [screen show];
}

-(viscreen*)init
{
    self = [super initWithFrame:screenrect];
    [self setClipsToBounds:YES];
    [self setAlpha:0];
    
    if([UIVisualEffectView class])
    {
        UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [blur setFrame:screenrect];
        [blur setUserInteractionEnabled:NO];
        
        [self addSubview:blur];
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.95]];
    }
    
    UIImageView *stronglogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, 150)];
    logo = stronglogo;
    [logo setClipsToBounds:YES];
    [logo setUserInteractionEnabled:NO];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    [logo setImage:[UIImage imageNamed:@"logo"]];
    
    UILabel *stronglblcurrent = [[UILabel alloc] initWithFrame:CGRectMake(screenwidth_2 - 150, 150, 300, 20)];
    lblcurrent = stronglblcurrent;
    [lblcurrent setBackgroundColor:[UIColor clearColor]];
    [lblcurrent setTextAlignment:NSTextAlignmentCenter];
    [lblcurrent setFont:[UIFont fontWithName:fontboldname size:14]];
    [lblcurrent setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [lblcurrent setUserInteractionEnabled:NO];
    
    UILabel *stronglblscore = [[UILabel alloc] initWithFrame:CGRectMake(screenwidth_2 - 150, 170, 300, 20)];
    lblscore = stronglblscore;
    [lblscore setBackgroundColor:[UIColor clearColor]];
    [lblscore setTextAlignment:NSTextAlignmentCenter];
    [lblscore setFont:[UIFont fontWithName:fontname size:14]];
    [lblscore setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
    [lblscore setUserInteractionEnabled:NO];
    
    UIButton *strongbtnscore = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 - 70, 330, 60, 60)];
    btnscores = strongbtnscore;
    [btnscores setImage:[UIImage imageNamed:@"scores"] forState:UIControlStateNormal];
    [btnscores addTarget:self action:@selector(actionscores) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *strongbtninstructions = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 + 10, 330, 60, 60)];
    btninstructions = strongbtninstructions;
    [btninstructions setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [btninstructions addTarget:self action:@selector(actioninstructions) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *strongbtnstore = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 - 30, 400, 60, 60)];
    btnstore = strongbtnstore;
    [btnstore setImage:[UIImage imageNamed:@"store"] forState:UIControlStateNormal];
    [btnstore addTarget:self action:@selector(actionstore) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:logo];
    [self addSubview:lblcurrent];
    [self addSubview:lblscore];
    [self addSubview:btnscores];
    [self addSubview:btninstructions];
    [self addSubview:btnstore];
    
    switch([ctrmain sha].game.state)
    {
        case gamestatenotstarted:
        {
            UIButton *strongbtnnewgame = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 - 60, 200, 120, 40)];
            btnnewgame = strongbtnnewgame;
            [btnnewgame setBackgroundColor:colorblue];
            [btnnewgame setClipsToBounds:YES];
            [btnnewgame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnnewgame setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateHighlighted];
            [btnnewgame setTitle:NSLocalizedString(@"screen_newgame", nil) forState:UIControlStateNormal];
            [btnnewgame.titleLabel setFont:[UIFont fontWithName:fontname size:16]];
            [btnnewgame.layer setCornerRadius:6];
            [btnnewgame addTarget:self action:@selector(actionnewgame) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btnnewgame];
        }
            break;
            
        case gamestatenormal:
        {
            UIButton *strongbtnresume = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 - 60, 200, 120, 40)];
            btnresume = strongbtnresume;
            [btnresume setBackgroundColor:colorblue];
            [btnresume setClipsToBounds:YES];
            [btnresume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnresume setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateHighlighted];
            [btnresume setTitle:NSLocalizedString(@"screen_resume", nil) forState:UIControlStateNormal];
            [btnresume.titleLabel setFont:[UIFont fontWithName:fontname size:16]];
            [btnresume.layer setCornerRadius:6];
            [btnresume addTarget:self action:@selector(actionresume) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *strongbtnrestart = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 - 60, 270, 120, 40)];
            btnrestart = strongbtnrestart;
            [btnrestart setBackgroundColor:colorred];
            [btnrestart setClipsToBounds:YES];
            [btnrestart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnrestart setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateHighlighted];
            [btnrestart setTitle:NSLocalizedString(@"screen_restart", nil) forState:UIControlStateNormal];
            [btnrestart.titleLabel setFont:[UIFont fontWithName:fontname size:16]];
            [btnrestart.layer setCornerRadius:6];
            [btnrestart addTarget:self action:@selector(actionrestart) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btnresume];
            [self addSubview:btnrestart];
        }
            break;
            
        case gamestatefinished:
        {
            UILabel *stronglbldied = [[UILabel alloc] initWithFrame:CGRectMake(screenwidth_2 - 100, 200, 200, 40)];
            lbldied = stronglbldied;
            [lbldied setBackgroundColor:[UIColor clearColor]];
            [lbldied setUserInteractionEnabled:NO];
            [lbldied setTextAlignment:NSTextAlignmentCenter];
            [lbldied setFont:[UIFont fontWithName:fontboldname size:24]];
            [lbldied setTextColor:[UIColor blackColor]];
            [lbldied setText:NSLocalizedString(@"screen_died", nil)];
            
            UIButton *strongbtnnewgame = [[UIButton alloc] initWithFrame:CGRectMake(screenwidth_2 - 60, 270, 120, 40)];
            btnnewgame = strongbtnnewgame;
            [btnnewgame setBackgroundColor:colorblue];
            [btnnewgame setClipsToBounds:YES];
            [btnnewgame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnnewgame setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateHighlighted];
            [btnnewgame setTitle:NSLocalizedString(@"screen_newgame", nil) forState:UIControlStateNormal];
            [btnnewgame.titleLabel setFont:[UIFont fontWithName:fontname size:16]];
            [btnnewgame.layer setCornerRadius:6];
            [btnnewgame addTarget:self action:@selector(actionrestart) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:lbldied];
            [self addSubview:btnnewgame];
        }
            break;
    }
    
    return self;
}

#pragma mark actions

-(void)actionnewgame
{
    [self hide];
    [[ctrmain sha].game startgame];
}

-(void)actionresume
{
    [self hide];
    [[ctrmain sha].game resumegame];
}

-(void)actionrestart
{
    [self hide];
    [[ctrmain sha].game restartgame];
}

-(void)actionscores
{
    [[gkman sha] showleaders];
}

-(void)actioninstructions
{
    [viinstrs show];
}

-(void)actionstore
{
    [[skman sha] checkavailabilities];
}

#pragma mark functionality

-(void)show
{
    [UIView animateWithDuration:0.4 animations:
     ^(void)
     {
         [self setAlpha:1];
     } completion:
     ^(BOOL _done)
     {
         [lblscore setText:[NSString stringWithFormat:NSLocalizedString(@"screen_maxscore", nil), [[tools sha] scoretostring:[[[NSUserDefaults standardUserDefaults] valueForKey:propmaxscore] integerValue]]]];
         
         switch([ctrmain sha].game.state)
         {
                case gamestatenotstarted:
                 break;
                 
                case gamestatefinished:
                 
                 [lblcurrent setText:[NSString stringWithFormat:NSLocalizedString(@"screen_currentscore", nil), [[tools sha] scoretostring:[ctrmain sha].game.score]]];
                 
                 [[gkman sha] newscore:[ctrmain sha].game.score];
                 
                 break;
                 
                default:
                 
                 [lblcurrent setText:[NSString stringWithFormat:NSLocalizedString(@"screen_currentscore", nil), [[tools sha] scoretostring:[ctrmain sha].game.score]]];
                 
                 break;
         }
     }];
}

-(void)hide
{
    [UIView animateWithDuration:0.3 animations:
     ^(void)
     {
         [self setAlpha:0];
     } completion:
     ^(BOOL _done)
     {
         [self removeFromSuperview];
     }];
}

@end