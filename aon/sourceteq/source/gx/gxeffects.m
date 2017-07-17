#import "gxeffects.h"

@implementation gxeffects
{
    NSMutableArray *array;
}

-(gxeffects*)init
{
    self = [super init];
    array = [NSMutableArray array];
    
    return self;
}

#pragma mark public

-(void)add:(gxeffect*)_effect
{
    [array addObject:_effect];
}

-(void)tick
{
    NSInteger qty = array.count;

    for(NSInteger i = qty - 1; i >= 0; i--)
    {
        gxeffect *effect = array[i];
        effect.ttl--;
        
        if(effect.ttl < 0)
        {
            [array removeObjectAtIndex:i];
        }
    }
}

#pragma mark -
#pragma mark drawer del

-(void)render:(GLKBaseEffect*)_effect
{
    NSInteger qty = array.count;
    
    for(NSInteger i = 0; i < qty; i++)
    {
        gxeffect *effect = array[i];
        [effect render:_effect];
    }
}

@end

@implementation gxeffect
{
    NSMutableData *mutdataposition;
    NSMutableData *mutdatatexture;
    GLKVector2 *vecpos;
    GLKVector2 *vectex;
    GLKTextureInfo *texture;
    GLKVector4 color;
    GLuint texturename;
    GLKMatrix4 rotation;
}

@synthesize type;
@synthesize posx;
@synthesize posy;
@synthesize size;
@synthesize ttl;

-(gxeffect*)init:(effecttype)_type posx:(CGFloat)_posx posy:(CGFloat)_posy
{
    self = [super init];
    
    type = _type;
    posx = _posx;
    posy = _posy;
    
    switch(type)
    {
        case effecttypecrash:
            
            ttl = 35;
            size = 30;
            color = GLKVector4Make(0.9, 0.95, 1, 0.7);
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"crash"].CGImage options:nil error:nil];
            
            break;
            
        case effecttypeunbrick:
            
            ttl = 15;
            size = 30;
            color = GLKVector4Make(1, 0.6, 0, 1);
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"unbricker"].CGImage options:nil error:nil];
            
            break;
            
        case effecttypepumper:
            
            ttl = 30;
            size = 20;
            color = GLKVector4Make(0.1372, 0.6705, 0.8705, 0.2);
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"pumper"].CGImage options:nil error:nil];
            
            break;
            
        case effecttypeunheart:
            
            ttl = 25;
            size = 40;
            color = GLKVector4Make(1, 0.15, 0, 0.3);
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"unhearter"].CGImage options:nil error:nil];
            
            break;
            
        case effecttypestarter:
            
            ttl = 22;
            size = 60;
            color = GLKVector4Make(0.8, 0.9, 1, 0.4);
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"starter"].CGImage options:nil error:nil];
            
            break;
    }
    
    CGFloat midsize = size / 2;
    CGFloat minx = -midsize;
    CGFloat miny = -midsize;
    CGFloat maxx = midsize;
    CGFloat maxy = midsize;
    CGFloat rot = arc4random_uniform(360) * M_PI / 180;
    
    mutdataposition = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    mutdatatexture = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    vecpos = mutdataposition.mutableBytes;
    vectex = mutdatatexture.mutableBytes;
    texturename = texture.name;
    rotation = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(posx, posy, 0), GLKMatrix4MakeRotation(rot, 0, 0, 1));
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

-(void)dealloc
{
    glDeleteTextures(1, &texturename);
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