#import "gxbricks.h"

@implementation gxbricks
{
    NSMutableArray *array;
    NSMutableArray *visarray;
    CGFloat brickminspeed;
    CGFloat brickmaxspeed;
    CGFloat ratbrick;
    CGFloat speedmult;
    CGFloat averspeed;
    CGFloat averspeed2;
    CGFloat brickminwidth;
    CGFloat brickmaxwidth;
    CGFloat brickaverwidth;
    CGFloat levelup;
    NSInteger maxbricks;
    NSInteger clockcounter;
    NSInteger perkratio;
}

@synthesize game;

-(gxbricks*)init:(ctrgame*)_game;
{
    self = [super init];
    
    switch(applicationtype)
    {
        case apptypepad:
            
//            brickmaxspeed = 3;
            brickmaxspeed = 1;
            
            break;
            
        case apptypephone:
            
//            brickmaxspeed = 1.2;
            
            if(screenwidth > 320)
            {
                brickmaxspeed = 0.7;
            }
            else
            {
                brickmaxspeed = 0.5;
            }
            
            break;
    }
    
    game = _game;
//    maxbricks = 100;
    maxbricks = 50;
    brickminspeed = 0.002;
    speedmult = 1000;
    averspeed = (brickmaxspeed - brickminspeed) * speedmult;
    averspeed2 = averspeed * 2;
    ratbrick = 50;
    brickminwidth = 10;
    brickmaxwidth = 60;
    brickaverwidth = brickmaxwidth - brickminwidth;
    array = [NSMutableArray array];
    levelup = 5;
    clockcounter = 0;
    perkratio = 10;
    
    if((perkstatus)[[[NSUserDefaults standardUserDefaults] valueForKey:proppurdouble] integerValue] == perkstatuspurchased)
    {
        perkratio /= 2;
    }
    
    return self;
}

#pragma mark functionality

-(void)addbrick
{
    NSInteger actual = array.count;
    
    if(actual < maxbricks)
    {
        if(arc4random_uniform(ratbrick) == 0)
        {
            BOOL notfound = YES;
            CGFloat thisbrickwidth = arc4random_uniform(brickaverwidth) + brickminwidth;
            CGFloat thisbrickwidth_2 = thisbrickwidth / 2;
            CGFloat xpos = arc4random_uniform(screenwidth - thisbrickwidth) + thisbrickwidth_2;
            CGFloat ypos = 0;
            NSInteger level = 0;

            while(arc4random_uniform(levelup) == 0)
            {
                if(level < 9)
                {
                    level++;
                }
                else
                {
                    break;
                }
            }
            
            while(notfound)
            {
                notfound = NO;
                ypos -= thisbrickwidth;
                
                CGFloat minx = xpos - thisbrickwidth_2;
                CGFloat maxx = xpos + thisbrickwidth_2;
                CGFloat miny = ypos - thisbrickwidth_2;
                CGFloat maxy = ypos + thisbrickwidth_2;
                
                for(NSInteger i = 0; i < actual; i++)
                {
                    gxbrick *other = array[i];
                    CGFloat otherx = other.xpos;
                    CGFloat othery = other.ypos;
                    CGFloat otherwidth_2 = other.midwidth;
                    CGFloat otherminx = otherx - otherwidth_2;
                    CGFloat othermaxx = otherx + otherwidth_2;
                    CGFloat otherminy = othery - otherwidth_2;
                    CGFloat othermaxy = othery + otherwidth_2;
                    
                    if(miny <= othermaxy)
                    {
                        if(maxy >= otherminy)
                        {
                            if(minx <= othermaxx)
                            {
                                if(maxx >= otherminx)
                                {
                                    notfound = YES;
                                    i = actual;
                                }
                            }
                        }
                    }
                }
            }
            
            CGFloat xspeed = (arc4random_uniform(averspeed2) - averspeed) / speedmult;
            CGFloat yspeed = (arc4random_uniform(averspeed) / speedmult) + brickminspeed;
            
            [array addObject:[[gxbrick alloc] init:xpos ypos:ypos xspeed:xspeed yspeed:yspeed midwidth:thisbrickwidth_2 level:level perkratio:perkratio]];
        }
    }
}

-(void)removebrick:(gxbrick*)_brick gain:(BOOL)_gain
{
    [game unbricked:_brick gain:_gain];
    [array removeObject:_brick];
}

#pragma mark public

-(void)tick
{
    [self addbrick];
    
    NSInteger qty = array.count;
    visarray = [NSMutableArray array];
    
    for(NSInteger i = qty - 1; i >= 0; i--)
    {
        gxbrick *brick = array[i];
        
        CGFloat brickxspeed;
        CGFloat brickyspeed;
        
        if(clockcounter)
        {
            brickxspeed = brick.xspeed_half;
            brickyspeed = brick.yspeed_half;
        }
        else
        {
            brickxspeed = brick.xspeed;
            brickyspeed = brick.yspeed;
        }
        
        CGFloat brickx = brick.xpos + brickxspeed;
        CGFloat bricky = brick.ypos + brickyspeed;
        CGFloat thisbrickwidth_2 = brick.midwidth;
        CGFloat brickminx = brickx - thisbrickwidth_2;
        CGFloat brickmaxx = brickx + thisbrickwidth_2;
        CGFloat brickminy = bricky - thisbrickwidth_2;
        CGFloat brickmaxy = bricky + thisbrickwidth_2;
        
        if(brickxspeed < 0)
        {
            if(brickminx < 0)
            {
                brickx = thisbrickwidth_2;
                brick.xspeed = fabsf(brickxspeed);
                
                brickminx = brickx - thisbrickwidth_2;
                brickmaxx = brickx + thisbrickwidth_2;
            }
        }
        else if(brickxspeed > 0)
        {
            if(brickmaxx > screenwidth)
            {
                brickx = screenwidth - thisbrickwidth_2;
                brick.xspeed = -fabsf(brickxspeed);
                
                brickminx = brickx - thisbrickwidth_2;
                brickmaxx = brickx + thisbrickwidth_2;
            }
        }
        
        NSInteger inqty = array.count;
        
        for(NSInteger j = 0; j < inqty; j++)
        {
            if(j != i)
            {
                gxbrick *other = array[j];
                
                CGFloat otherx = other.xpos;
                CGFloat othery = other.ypos;
                CGFloat otherbrickwidth_2 = other.midwidth;
                CGFloat otherminx = otherx - otherbrickwidth_2;
                CGFloat othermaxx = otherx + otherbrickwidth_2;
                CGFloat otherminy = othery - otherbrickwidth_2;
                CGFloat othermaxy = othery + otherbrickwidth_2;
                
                if(brickmaxy >= otherminy)
                {
                    if(brickminy <= othermaxy)
                    {
                        if(brickmaxx >= otherminx)
                        {
                            if(brickminx <= othermaxx)
                            {
                                brick.xspeed = -brickxspeed;
                                brickx = brick.xpos;
                                bricky = brick.ypos;
                                j = inqty;
                            }
                        }
                    }
                }
            }
        }
        
        brick.xpos = brickx;
        brick.ypos = bricky;
        
        if(brickminy < displayheight)
        {
            if(brickmaxy > 0)
            {
                if([game.hearts breakme:brick])
                {
                    [self removebrick:brick gain:NO];
                }
                else
                {
                    [visarray addObject:brick];
                }
            }
        }
        else
        {
            [array removeObject:brick];
        }
    }
}

-(void)movebricks
{
    NSInteger visible = visarray.count;
    
    for(NSInteger i = 0; i < visible; i++)
    {
        gxbrick *brick = visarray[i];
        [brick redimmension];
    }
}

-(void)gohalfspeed
{
    clockcounter++;
}

-(void)diedhalfspeed
{
    clockcounter--;
}

#pragma mark -
#pragma mark drawer del

-(void)render:(GLKBaseEffect*)_effect
{
    NSInteger visible = visarray.count;
    
    for(NSInteger i = 0; i < visible; i++)
    {
        gxbrick *brick = visarray[i];
        [brick render:_effect];
    }
}

#pragma mark bouncer del

-(void)ricochet:(gxball*)_ball
{
    CGFloat ballxspeed = fabsf(_ball.xspeed);
    CGFloat ballyspeed = fabsf(_ball.yspeed);
    CGFloat ballxpos = _ball.xpos;
    CGFloat ballypos = _ball.ypos;
    CGFloat ballradius = _ball.radius;
    CGFloat ballminx = ballxpos - ballradius;
    CGFloat ballmaxx = ballxpos + ballradius;
    CGFloat ballminy = ballypos - ballradius;
    CGFloat ballmaxy = ballypos + ballradius;
    NSInteger total = array.count;
    
    for(NSInteger i = total - 1; i >= 0; i--)
    {
        gxbrick *brick = array[i];
        CGFloat brickx = brick.xpos;
        CGFloat bricky = brick.ypos;
        CGFloat thisbrickwidth_2 = brick.midwidth;
        CGFloat brickminx = brickx - thisbrickwidth_2;
        CGFloat brickmaxx = brickx + thisbrickwidth_2;
        CGFloat brickminy = bricky - thisbrickwidth_2;
        CGFloat brickmaxy = bricky + thisbrickwidth_2;
        
        if(ballminx <= brickmaxx)
        {
            if(ballmaxx >= brickminx)
            {
                if(ballminy <= brickmaxy)
                {
                    if(ballmaxy >= brickminy)
                    {
                        if(!_ball.starcounter)
                        {
                            if(ballxpos > brickx)
                            {
                                _ball.xspeed = ballxspeed;
                            }
                            else
                            {
                                _ball.xspeed = -ballxspeed;
                            }
                            
                            if(ballypos > bricky)
                            {
                                _ball.yspeed = ballyspeed;
                            }
                            else
                            {
                                _ball.yspeed = -ballyspeed;
                            }
                            
                            [_ball bounce];
                        }
                        
                        if(brick.level)
                        {
                            [brick godown];
                        }
                        else
                        {
                            [self removebrick:brick gain:YES];
                        }
                    }
                }
            }
        }
    }
}

@end

@implementation gxbrick
{
    NSMutableData *mutdataposition;
    NSMutableData *mutdatatexture;
    GLKVector2 *vecpos;
    GLKVector2 *vectex;
    GLKTextureInfo *texture;
    GLuint texturename;
    GLKMatrix4 rotation;
}

@synthesize color;
@synthesize xpos;
@synthesize ypos;
@synthesize xspeed;
@synthesize yspeed;
@synthesize xspeed_half;
@synthesize yspeed_half;
@synthesize midwidth;
@synthesize orlevel;
@synthesize level;
@synthesize perky;

-(gxbrick*)init:(CGFloat)_xpos ypos:(CGFloat)_ypos xspeed:(CGFloat)_xspeed yspeed:(CGFloat)_yspeed midwidth:(CGFloat)_midwidth level:(NSInteger)_level perkratio:(NSInteger)_perkratio
{
    self = [super init];
    
    xpos = _xpos;
    ypos = _ypos;
    xspeed = _xspeed;
    yspeed = _yspeed;
    xspeed_half = xspeed / 2;
    yspeed_half = yspeed / 2;
    midwidth = _midwidth;
    orlevel = level = _level;
    
    mutdataposition = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    mutdatatexture = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    vecpos = mutdataposition.mutableBytes;
    vectex = mutdatatexture.mutableBytes;
    
    texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"brick"].CGImage options:nil error:nil];
    texturename = texture.name;
    rotation = GLKMatrix4MakeRotation(0, 0, 0, 1);
    
    vectex[0] = GLKVector2Make(0, 0);
    vectex[1] = GLKVector2Make(0, 1);
    vectex[2] = GLKVector2Make(1, 1);
    vectex[3] = GLKVector2Make(1, 1);
    vectex[4] = GLKVector2Make(1, 0);
    vectex[5] = GLKVector2Make(0, 0);
    
    if(arc4random_uniform((int)_perkratio) == 0)
    {
        perky = arc4random_uniform(perktypenone);
    }
    else
    {
        perky = perktypenone;
    }
    
    [self levelize];
    
    return self;
}

-(void)dealloc
{
    glDeleteTextures(1, &texturename);
}

#pragma mark functions

-(void)levelize
{
    switch(level)
    {
        case 0:
            
            color = GLKVector4Make(1, 0.6, 0, 1);
            
            break;
            
        case 1:
            
            color = GLKVector4Make(1, 0.9, 0, 1);
            
            break;
            
        case 2:
            
            color = GLKVector4Make(1, 0.15, 0, 1);
            
            break;
            
        case 3:
            
            color = GLKVector4Make(1, 0.7, 0.7, 1);
            
            break;
            
        case 4:
            
            color = GLKVector4Make(1, 0.4, 0.4, 1);
            
            break;
            
        case 5:
            
            color = GLKVector4Make(0.6, 0.6, 0, 1);
            
            break;
            
        case 6:
            
            color = GLKVector4Make(0.8, 0.8, 0.8, 1);
            
            break;
            
        case 7:
            
            color = GLKVector4Make(0.6, 0.6, 0.6, 1);
            
            break;
            
        case 8:
            
            color = GLKVector4Make(0.4, 0.4, 0.4, 1);
            
            break;
            
        case 9:
            
            color = GLKVector4Make(0.2, 0.2, 0.2, 1);
            
            break;
    }
}

#pragma mark public

-(void)redimmension
{
    CGFloat minx = xpos - midwidth;
    CGFloat maxx = xpos + midwidth;
    CGFloat miny = ypos - midwidth;
    CGFloat maxy = ypos + midwidth;
    
    vecpos[0] = GLKVector2Make(minx, miny);
    vecpos[1] = GLKVector2Make(minx, maxy);
    vecpos[2] = GLKVector2Make(maxx, maxy);
    vecpos[3] = GLKVector2Make(maxx, maxy);
    vecpos[4] = GLKVector2Make(maxx, miny);
    vecpos[5] = GLKVector2Make(minx, miny);
}

-(void)godown
{
    level--;
    [self levelize];
}

#pragma mark -
#pragma mark drawer del

-(void)render:(GLKBaseEffect*)_effect
{
    _effect.transform.modelviewMatrix = rotation;
    _effect.texture2d0.name = texturename;
    _effect.texture2d0.envMode = GLKTextureEnvModeModulate;
    _effect.constantColor = color;
    [_effect prepareToDraw];
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vecpos);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, vectex);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end