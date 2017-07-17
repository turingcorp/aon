#import "ctrgame.h"

@implementation ctrgame
{
    timerbg *timer;
    CGFloat ballx;
    CGFloat bally;
    CGFloat barx;
    CGFloat bary;
}

@synthesize ball;
@synthesize bar;
@synthesize bricks;
@synthesize hearts;
@synthesize effects;
@synthesize state;
@synthesize score;
@synthesize perks;

-(ctrgame*)init
{
    self = [super init];
    
    timer = [timerbg millis:10 leeway:1000 delegate:self background:NO];
    state = gamestatenotstarted;
    [self initgame];
    
    return self;
}

#pragma mark functionality

-(void)initgame
{
    ballx = barx = screenwidth_2;
    bally = displayheight - 300;
    
    switch(applicationtype)
    {
        case apptypepad:
            
//            bary = displayheight - 180;
            bary = displayheight - 50;
            
            break;
            
        case apptypephone:
            
//            bary = displayheight - 100;
            bary = displayheight - 40;
            
            break;
    }
    
    ball = [[gxball alloc] init:ballx ypos:bally];
    bar = [[gxbar alloc] init:self xpos:barx ypos:bary];
    bricks = [[gxbricks alloc] init:self];
    hearts = [[gxhearts alloc] init:self];
    effects = [[gxeffects alloc] init];
    perks = [[gxperks alloc] init:self];
}

-(void)postscore
{
    [[ctrmain sha].hub newscore:[[tools sha] scoretostring:score]];
}

-(void)tick
{
    // ricochet
    
    [bar ricochet:ball];
    [bricks ricochet:ball];
    [hearts ricochet:ball];
    
    // move bar
    
    CGFloat barxspeed = bar.xspeed;
    CGFloat bardesiredx = bar.desiredxpos;
    barx += barxspeed;
    
    if(barxspeed > 0)
    {
        if(barx >= bardesiredx)
        {
            barx = bardesiredx;
            bar.xspeed = 0;
        }
    }
    else if(barxspeed < 0)
    {
        if(barx <= bardesiredx)
        {
            barx = bardesiredx;
            bar.xspeed = 0;
        }
    }
    
    CGFloat barwidth_2 = bar.width_2;
    CGFloat barminx = barx - barwidth_2;
    CGFloat barmaxx = barx + barwidth_2;
    
    if(barminx < 0)
    {
        barx = barwidth_2;
    }
    else if(barmaxx > screenwidth)
    {
        barx = screenwidth - barwidth_2;
    }
    
    // move ball
    
    ballx += ball.xspeed;
    bally += ball.yspeed;
    
    CGFloat ballradius = ball.radius;
    CGFloat ballminx = ballx - ballradius;
    CGFloat ballmaxx = ballx + ballradius;
    CGFloat ballminy = bally - ballradius;
    CGFloat ballmaxy = bally + ballradius;
    
    if(ballminy < 0)
    {
        bally = ballradius;
        ball.yspeed = fabsf(ball.yspeed);
        
        [ball bounce];
        [effects add:[[gxeffect alloc] init:effecttypecrash posx:ballx posy:0]];
    }
    else if(ballmaxy > displayheight)
    {
        bally = displayheight - ballradius;
        ball.yspeed = -fabsf(ball.yspeed);
        
        [ball bounce];
        [effects add:[[gxeffect alloc] init:effecttypecrash posx:ballx posy:displayheight]];
    }
    
    if(ballminx < 0)
    {
        ballx = ballradius;
        ball.xspeed = fabsf(ball.xspeed);
        
        [ball bounce];
        [effects add:[[gxeffect alloc] init:effecttypecrash posx:0 posy:bally]];
    }
    else if(ballmaxx > screenwidth)
    {
        ballx = screenwidth - ballradius;
        ball.xspeed = -fabsf(ball.xspeed);
        
        [ball bounce];
        [effects add:[[gxeffect alloc] init:effecttypecrash posx:screenwidth posy:bally]];
    }
    
    [bricks tick];
    [effects tick];
    [perks tick];
}

#pragma mark gesture

-(void)desiredposition:(CGFloat)_x
{
    bar.desiredxpos = _x;
    CGFloat barxpos = bar.xpos;
    CGFloat barspeed = bar.speed;
    
    if(_x > barxpos)
    {
        if(_x - barspeed >= barxpos)
        {
            bar.xspeed = barspeed;
        }
        else
        {
            bar.xspeed = _x - barxpos;
        }
    }
    else
    {
        if(_x + barspeed <= barxpos)
        {
            bar.xspeed = -barspeed;
        }
        else
        {
            bar.xspeed = _x - barxpos;
        }
    }
}

#pragma mark public

-(void)startgame
{
    score = 0;
    ball.yspeed = - (ball.maxspeed - ball.minspeed);
    [self resumegame];
}

-(void)resumegame
{
    [[ctrmain sha] setPaused:NO];
    [timer resume];
    [self postscore];
    state = gamestatenormal;
}

-(void)pausegame
{
    [timer pause];
    [viscreen show];
}

-(void)restartgame
{
    [self initgame];
    [[ctrmain sha].drawer newgame:self];
    [self startgame];
}

-(void)render
{
    [ball centerx:ballx y:bally];
    [bar centerx:barx y:bary];
    [bricks movebricks];
    [perks repos];
}

-(void)unbricked:(gxbrick*)_brick gain:(BOOL)_gain
{
    if(_gain)
    {
        NSInteger points = _brick.orlevel + 1;
        score += points * points;
        perktype perky = _brick.perky;
        
        if(perky != perktypenone)
        {
            [perks add:[[gxperk alloc] init:perky posx:_brick.xpos posy:_brick.ypos]];
        }
    }
    
    [effects add:[[gxeffect alloc] init:effecttypeunbrick posx:_brick.xpos posy:_brick.ypos]];
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    
    if([[userdef valueForKey:propmaxscore] integerValue] < score)
    {
        [userdef setValue:@(score) forKey:propmaxscore];
    }
    
    [self postscore];
}

-(void)pumping
{
    [effects add:[[gxeffect alloc] init:effecttypepumper posx:ball.xpos posy:ball.ypos]];
}

-(void)unheart:(gxheart*)_heart
{
    [effects add:[[gxeffect alloc] init:effecttypeunheart posx:_heart.xpos posy:_heart.ypos]];
}

-(void)perkontheloose:(gxperk*)_perk
{
    CGFloat perkmidsize = _perk.midsize;
    CGFloat barmidheight = bar.height_2;
    CGFloat barmidwidth = bar.width_2;
    CGFloat perkx = _perk.posx;
    CGFloat perky = _perk.posy;
    CGFloat perkminy = perky - perkmidsize;
    CGFloat perkmaxy = perky + perkmidsize;
    CGFloat perkminx = perkx - perkmidsize;
    CGFloat perkmaxx = perkx + perkmidsize;
    CGFloat barminy = bary - barmidheight;
    CGFloat barmaxy = bary + barmidheight;
    CGFloat barminx = barx - barmidwidth;
    CGFloat barmaxx = barx + barmidwidth;
    
    if(perkminy <= barmaxy)
    {
        if(perkmaxy >= barminy)
        {
            if(perkminx <= barmaxx)
            {
                if(perkmaxx >= barminx)
                {
                    [effects add:[[gxeffect alloc] init:effecttypestarter posx:perkx posy:perky]];
                    
                    switch(_perk.type)
                    {
                        case perktypenone:
                            break;
                            
                        case perktypelife:
                            
                            [hearts addheart];
                            
                            break;
                            
                        case perktypebigball:
                            
                            [ball gobig];
                            
                            break;
                            
                        case perktypebigbar:
                            
                            [bar gobig];
                            
                            break;
                            
                        case perktypeclock:
                            
                            [bricks gohalfspeed];
                            
                            break;
                            
                        case perktypestarball:
                            
                            [ball gostart];
                            
                            break;
                            
                        case perktypestarheart:
                            
                            [hearts gostar];
                            
                            break;
                    }
                    
                    _perk.taken = YES;
                }
            }
        }
    }
}

-(void)perkexpired:(gxperk*)_perk
{
    switch(_perk.type)
    {
        case perktypenone:
            break;
        case perktypelife:
            break;
        case perktypebigball:
            
            [ball diedbig];
            
            break;
            
        case perktypebigbar:
            
            [bar diedbig];
            
            break;
            
        case perktypeclock:
            
            [bricks diedhalfspeed];
            
            break;
            
        case perktypestarball:
            
            [ball diedstar];
            
            break;
            
        case perktypestarheart:
            
            [hearts diedstar];
            
            break;
    }
}

-(void)endgame
{
    state = gamestatefinished;
    [[ctrmain sha] setPaused:YES];
}

#pragma mark -
#pragma mark timer del

-(void)timerbgtick
{
    [self tick];
}

@end