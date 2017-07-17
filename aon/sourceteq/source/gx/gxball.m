#import "gxball.h"

@implementation gxball
{
    NSMutableData *mutdataposition;
    NSMutableData *mutdatatexture;
    GLKVector2 *vecpos;
    GLKVector2 *vectex;
    GLKTextureInfo *texture;
    GLKVector4 color;
    GLKVector4 regularcolor;
    GLKVector4 starcolor;
    GLuint texturename;
    GLKMatrix4 rotation;
    CGFloat regularradius;
    CGFloat bigradius;
    CGFloat smallradius;
    NSInteger bigcounter;
    NSInteger smallcounter;
}

@synthesize radius;
@synthesize xpos;
@synthesize ypos;
@synthesize maxspeed;
@synthesize minspeed;
@synthesize xspeed;
@synthesize yspeed;
@synthesize starcounter;

-(gxball*)init:(CGFloat)_xpos ypos:(CGFloat)_ypos
{
    self = [super init];
    
    mutdataposition = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    mutdatatexture = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    vecpos = mutdataposition.mutableBytes;
    vectex = mutdatatexture.mutableBytes;
    
    texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"ball"].CGImage options:nil error:nil];
    texturename = texture.name;
    rotation = GLKMatrix4MakeRotation(0, 0, 0, 1);
    regularcolor = color = GLKVector4Make(0.1372, 0.6705, 0.8705, 1);
    starcolor = GLKVector4Make(1, 0.15, 0, 1);
    bigcounter = 0;
    smallcounter = 0;
    starcounter = 0;
    
    vectex[0] = GLKVector2Make(0, 0);
    vectex[1] = GLKVector2Make(0, 1);
    vectex[2] = GLKVector2Make(1, 1);
    vectex[3] = GLKVector2Make(1, 1);
    vectex[4] = GLKVector2Make(1, 0);
    vectex[5] = GLKVector2Make(0, 0);
    
    regularradius = radius = 20;
    smallradius = regularradius / 2;
    bigradius = regularradius * 2;
    xpos = _xpos;
    ypos = _ypos;
    xspeed = 0;
    yspeed = 0;
    
    switch(applicationtype)
    {
        case apptypepad:
            
//            maxspeed = 22;
//            minspeed = 8;
            maxspeed = 15;
            minspeed = 6;
            
            break;
            
        case apptypephone:
            
//            maxspeed = 12;
//            minspeed = 4;
            
            if(screenwidth > 320)
            {
                maxspeed = 9;
                minspeed = 6;
            }
            else
            {
                maxspeed = 7;
                minspeed = 5;
            }
            
            break;
    }
    
    return self;
}

-(void)dealloc
{
    glDeleteTextures(1, &texturename);
}

#pragma mark public

-(void)centerx:(CGFloat)_newx y:(CGFloat)_newy
{
    xpos = _newx;
    ypos = _newy;
    
    CGFloat minx = xpos - radius;
    CGFloat maxx = xpos + radius;
    CGFloat miny = ypos - radius;
    CGFloat maxy = ypos + radius;
    
    vecpos[0] = GLKVector2Make(minx, miny);
    vecpos[1] = GLKVector2Make(minx, maxy);
    vecpos[2] = GLKVector2Make(maxx, maxy);
    vecpos[3] = GLKVector2Make(maxx, maxy);
    vecpos[4] = GLKVector2Make(maxx, miny);
    vecpos[5] = GLKVector2Make(minx, miny);
}

-(void)bounce
{
    if(xspeed > 0)
    {
        if(xspeed > minspeed)
        {
            xspeed--;
            
            if(xspeed < minspeed)
            {
                xspeed = minspeed;
            }
        }
    }
    else if(xspeed < 0)
    {
        if(xspeed < -minspeed)
        {
            xspeed++;
            
            if(xspeed > -minspeed)
            {
                xspeed = -minspeed;
            }
        }
    }
    
    if(yspeed > 0)
    {
        if(yspeed > minspeed)
        {
            yspeed--;
            
            if(yspeed < minspeed)
            {
                yspeed = minspeed;
            }
        }
    }
    else if(yspeed < 0)
    {
        if(yspeed < -minspeed)
        {
            yspeed++;
            
            if(yspeed > -minspeed)
            {
                yspeed = -minspeed;
            }
        }
    }
}

-(void)gobig
{
    bigcounter++;
    radius = bigradius;
}

-(void)gosmall
{
    smallcounter++;
    radius = smallradius;
}

-(void)gostart
{
    starcounter++;
    color = starcolor;
}

-(void)diedbig
{
    bigcounter--;
    
    if(!bigcounter)
    {
        radius = regularradius;
    }
}

-(void)diedsmall
{
    smallcounter--;
    
    if(!smallcounter)
    {
        radius = regularradius;
    }
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
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vecpos);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, vectex);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end