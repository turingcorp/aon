#import "gxbar.h"

@implementation gxbar
{
    NSMutableData *mutdataposition;
    NSMutableData *mutdatatexture;
    GLKVector2 *vecpos;
    GLKVector2 *vectex;
    GLKTextureInfo *texture;
    GLKVector4 color;
    GLuint texturename;
    GLKMatrix4 rotation;
    CGFloat regularwidth;
    CGFloat bigwidth;
    CGFloat smallwidth;
    NSInteger bigcounter;
    NSInteger smallcounter;
}

@synthesize game;
@synthesize xpos;
@synthesize ypos;
@synthesize width;
@synthesize height;
@synthesize width_2;
@synthesize height_2;
@synthesize speed;
@synthesize xspeed;
@synthesize desiredxpos;

-(gxbar*)init:(ctrgame*)_game xpos:(CGFloat)_xpos ypos:(CGFloat)_ypos
{
    self = [super init];
    
    game = _game;
    mutdataposition = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    mutdatatexture = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    vecpos = mutdataposition.mutableBytes;
    vectex = mutdatatexture.mutableBytes;
    
    texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"bar"].CGImage options:nil error:nil];
    texturename = texture.name;
    rotation = GLKMatrix4MakeRotation(0, 0, 0, 1);
    color = GLKVector4Make(0.7, 0.9, 0, 1);
    
    vectex[0] = GLKVector2Make(0, 0);
    vectex[1] = GLKVector2Make(0, 1);
    vectex[2] = GLKVector2Make(1, 1);
    vectex[3] = GLKVector2Make(1, 1);
    vectex[4] = GLKVector2Make(1, 0);
    vectex[5] = GLKVector2Make(0, 0);
    
//    regularwidth = floorf(screenwidth / 4);
    regularwidth = floorf(screenwidth / 2.5);
    bigwidth = regularwidth * 2;
    smallwidth = regularwidth / 2;
    [self newwidth:regularwidth];
    height = floorf(width / 6);
    xpos = _xpos;
    ypos = _ypos;
    height_2 = height / 2;
    speed = 25;
    xspeed = 0;
    desiredxpos = xpos;
    bigcounter = 0;
    smallcounter = 0;
    
    return self;
}

-(void)dealloc
{
    glDeleteTextures(1, &texturename);
}

#pragma mark functions

-(void)newwidth:(CGFloat)_width
{
    width = _width;
    width_2 = width / 2;
}

#pragma mark public

-(void)centerx:(CGFloat)_newx y:(CGFloat)_newy
{
    xpos = _newx;
    ypos = _newy;
    
    CGFloat minx = xpos - width_2;
    CGFloat maxx = xpos + width_2;
    CGFloat miny = ypos - height_2;
    CGFloat maxy = ypos + height_2;
    
    vecpos[0] = GLKVector2Make(minx, miny);
    vecpos[1] = GLKVector2Make(minx, maxy);
    vecpos[2] = GLKVector2Make(maxx, maxy);
    vecpos[3] = GLKVector2Make(maxx, maxy);
    vecpos[4] = GLKVector2Make(maxx, miny);
    vecpos[5] = GLKVector2Make(minx, miny);
}

-(void)gobig
{
    bigcounter++;
    [self newwidth:bigwidth];
}

-(void)gosmall
{
    smallcounter++;
    [self newwidth:smallwidth];
}

-(void)diedbig
{
    bigcounter--;
    
    if(!bigcounter)
    {
        [self newwidth:regularwidth];
    }
}

-(void)diedsmall
{
    smallcounter--;
    
    if(!smallcounter)
    {
        [self newwidth:regularwidth];
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
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vecpos);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, vectex);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

#pragma mark bouncer del

-(void)ricochet:(gxball*)_ball
{
    CGFloat ballradius = _ball.radius;
    CGFloat ballxpos = _ball.xpos + _ball.xspeed;
    CGFloat ballypos = _ball.ypos + _ball.yspeed;
    CGFloat ballminx = ballxpos - ballradius;
    CGFloat ballmaxx = ballxpos + ballradius;
    CGFloat ballminy = ballypos - ballradius;
    CGFloat ballmaxy = ballypos + ballradius;
    CGFloat thisminx = xpos - width_2;
    CGFloat thismaxx = xpos + width_2;
    CGFloat thisminy = ypos - height_2;
    CGFloat thismaxy = ypos + height_2;
    
    if(ballminy <= thismaxy)
    {
        if(ballmaxy >= thisminy)
        {
            if(ballminx <= thismaxx)
            {
                if(ballmaxx >= thisminx)
                {
                    [game pumping];
                    [_ball bounce];
                    
                    CGFloat xspeed_2 = fabs(xspeed) / 6;
                    CGFloat ballxspeed = fabs(_ball.xspeed);
                    CGFloat ballyspeed = fabs(_ball.yspeed);
                    
                    ballxspeed += xspeed_2;
                    ballyspeed += xspeed_2;
                    
                    if(ballxpos >= thismaxx || ballxpos <= thisminx)
                    {
                        ballxspeed++;
                    }
                    else if(ballminx > thisminx && ballmaxx < thismaxx)
                    {
                        ballxspeed /= 2;
                    }
                    
                    if(ballxspeed > _ball.maxspeed)
                    {
                        ballxspeed = _ball.maxspeed;
                    }
                    
                    if(ballyspeed > _ball.maxspeed)
                    {
                        ballyspeed = _ball.maxspeed;
                    }
                    
                    if(ballxpos >= xpos)
                    {
                        _ball.xspeed = ballxspeed;
                    }
                    else
                    {
                        _ball.xspeed = -ballxspeed;
                    }
                    
                    if(ballypos < ypos)
                    {
                        _ball.yspeed = -ballyspeed;
                    }
                    else
                    {
                        _ball.yspeed = ballyspeed;
                    }
                }
            }
        }
    }
}

@end
