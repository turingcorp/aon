#import "gxhearts.h"

@implementation gxhearts
{
    NSTimer *timer;
    NSMutableArray *array;
    NSMutableArray *died;
    GLKTextureInfo *texture;
    GLKVector4 color;
    GLKVector4 regularcolor;
    GLKVector4 starcolor;
    GLuint texturename;
    GLKMatrix4 rotation;
    CGFloat heartwidth;
    CGFloat heartheight;
    CGFloat heartwidth_2;
    CGFloat heartheight_2;
    CGFloat heartsy;
    CGFloat heartsypos;
    NSInteger hearts;
    NSInteger starcounter;
}

@synthesize game;

-(gxhearts*)init:(ctrgame*)_game
{
    self = [super init];
    
    game = _game;
    starcounter = 0;
    heartwidth = 32;
    heartheight = 15;
    hearts = screenwidth / heartwidth;
    heartwidth_2 = heartwidth / 2;
    heartheight_2 = heartheight / 2;
    heartsy = displayheight - heartheight;
    regularcolor = color = GLKVector4Make(0.8, 0.86, 0.92, 1);
    starcolor = GLKVector4Make(0.2, 0.3, 0.4, 1);
    texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"heart"].CGImage options:nil error:nil];
    texturename = texture.name;
    rotation = GLKMatrix4MakeRotation(0, 0, 0, 1);
    array = [NSMutableArray array];
    died = [NSMutableArray array];
    heartsypos = heartsy + heartheight_2;
    CGFloat glxpos = heartwidth_2;
    
    for(NSInteger i = 0; i < hearts; i++)
    {
        [array addObject:[[gxheart alloc] init:glxpos ypos:heartsypos midwidth:heartwidth_2 midheight:heartheight_2 index:i]];
        glxpos += heartwidth;
    }
    
    return self;
}

-(void)dealloc
{
    glDeleteTextures(1, &texturename);
}

#pragma mark functionality

-(void)removeheart:(gxheart*)_heart
{
    if(!starcounter)
    {
        [died addObject:@(_heart.index)];
        [game unheart:_heart];
        [array removeObject:_heart];
        
        hearts--;
        
        if(hearts <= 0)
        {
            if(!timer)
            {
                timer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(endgame) userInfo:nil repeats:NO];
            }
        }
    }
}

-(void)endgame
{
    [timer invalidate];
    timer = nil;
    
    [game endgame];
}

#pragma mark public

-(BOOL)breakme:(gxbrick*)_brick
{
    CGFloat brickx = _brick.xpos + _brick.xspeed;
    CGFloat bricky = _brick.ypos + _brick.yspeed;
    CGFloat brickwidth_2 = _brick.midwidth;
    CGFloat brickminx = brickx - brickwidth_2;
    CGFloat brickmaxx = brickx + brickwidth_2;
    CGFloat brickmaxy = bricky + brickwidth_2;
    
    BOOL unbrick = NO;
    
    if(brickmaxy >= heartsy)
    {
        for(NSInteger i = hearts - 1; i >= 0; i--)
        {
            gxheart *heart = array[i];
            CGFloat heartx = heart.xpos;
            CGFloat heartminx = heartx - heartwidth_2;
            CGFloat heartmaxx = heartx + heartwidth_2;
            
            if(brickminx < heartmaxx)
            {
                if(brickmaxx > heartminx)
                {
                    unbrick = YES;
                    [self removeheart:heart];
                    
                    i = -1;
                }
            }
        }
    }
    
    return unbrick;
}

-(void)addheart
{
    if(died.count)
    {
        NSInteger index = [died[0] integerValue];
        [died removeObjectAtIndex:0];
        [array addObject:[[gxheart alloc] init:(heartwidth * index) + heartwidth_2 ypos:heartsypos midwidth:heartwidth_2 midheight:heartheight_2 index:index]];
        
        hearts++;
    }
}

-(void)gostar
{
    starcounter++;
    color = starcolor;
}

-(void)diedstar
{
    starcounter--;
    
    if(!starcounter)
    {
        color = regularcolor;
    }
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
    
    for(NSInteger i = 0; i < hearts; i++)
    {
        gxheart *heart = array[i];
        [heart render:_effect];
    }
}

#pragma mark ball del

-(void)ricochet:(gxball*)_ball
{
    CGFloat ballxspeed = _ball.xspeed;
    CGFloat ballyspeed = _ball.yspeed;
    CGFloat ballradius = _ball.radius;
    CGFloat ballxpos = _ball.xpos + ballxspeed;
    CGFloat ballypos = _ball.ypos + ballyspeed;
    CGFloat ballminx = ballxpos - ballradius;
    CGFloat ballmaxx = ballxpos + ballradius;
    CGFloat ballminy = ballypos - ballradius;
    CGFloat ballmaxy = ballypos + ballradius;
    
    for(NSInteger i = hearts - 1; i >= 0; i--)
    {
        gxheart *heart = array[i];
        CGFloat heartx = heart.xpos;
        CGFloat hearty = heart.ypos;
        CGFloat heartminx = heartx - heartwidth_2;
        CGFloat heartmaxx = heartx + heartwidth_2;
        CGFloat heartminy = hearty - heartheight_2;
        CGFloat heartmaxy = hearty + heartheight_2;
        
        if(ballminy < heartmaxy)
        {
            if(ballmaxy > heartminy)
            {
                if(ballminx < heartmaxx)
                {
                    if(ballmaxx > heartminx)
                    {
                        [self removeheart:heart];
                        
                        if(heartx > ballxpos)
                        {
                            _ball.xspeed = -fabs(ballxspeed);
                        }
                        else
                        {
                            _ball.xspeed = fabs(ballxspeed);
                        }
                        
                        _ball.yspeed = -fabs(ballyspeed);
                        
                        i = -1;
                    }
                }
            }
        }
    }
}

@end

@implementation gxheart
{
    NSMutableData *mutdataposition;
    NSMutableData *mutdatatexture;
    GLKVector2 *vecpos;
    GLKVector2 *vectex;
}

@synthesize xpos;
@synthesize ypos;
@synthesize index;

-(gxheart*)init:(CGFloat)_xpos ypos:(CGFloat)_ypos midwidth:(CGFloat)_midwidth midheight:(CGFloat)_midheight index:(NSInteger)_index
{
    self = [super init];

    index = _index;
    xpos = _xpos;
    ypos = _ypos;
    
    CGFloat minx = xpos - _midwidth;
    CGFloat miny = ypos - _midheight;
    CGFloat maxx = xpos + _midwidth;
    CGFloat maxy = ypos + _midheight;
    
    mutdataposition = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    mutdatatexture = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    vecpos = mutdataposition.mutableBytes;
    vectex = mutdatatexture.mutableBytes;
    
    vectex[0] = GLKVector2Make(0, 0);
    vectex[1] = GLKVector2Make(0, 1);
    vectex[2] = GLKVector2Make(1, 1);
    vectex[3] = GLKVector2Make(1, 1);
    vectex[4] = GLKVector2Make(1, 0);
    vectex[5] = GLKVector2Make(0, 0);
    vecpos[0] = GLKVector2Make(minx, miny);
    vecpos[1] = GLKVector2Make(minx, maxy);
    vecpos[2] = GLKVector2Make(maxx, maxy);
    vecpos[3] = GLKVector2Make(maxx, maxy);
    vecpos[4] = GLKVector2Make(maxx, miny);
    vecpos[5] = GLKVector2Make(minx, miny);
    
    return self;
}

#pragma mark -
#pragma mark drawer del

-(void)render:(GLKBaseEffect*)_effect
{
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vecpos);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, vectex);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
