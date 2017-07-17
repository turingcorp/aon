#import "gxperks.h"

@implementation gxperks
{
    NSMutableArray *array;
}

@synthesize game;

-(gxperks*)init:(ctrgame*)_game
{
    self = [super init];
    game = _game;
    array = [NSMutableArray array];
    
    return self;
}

#pragma mark public

-(void)add:(gxperk*)_perk
{
    [array addObject:_perk];
}

-(void)repos
{
    NSInteger qty = array.count;
    
    for(NSInteger i = 0; i < qty; i++)
    {
        gxperk *perk = array[i];
        
        if(!perk.taken)
        {
            [perk repos];
        }
    }
}

-(void)tick
{
    NSInteger qty = array.count;
    
    for(NSInteger i = qty - 1; i >= 0; i--)
    {
        gxperk *perk = array[i];
        
        if(perk.taken)
        {
            perk.ttl--;
            
            if(perk.ttl < 0)
            {
                [game perkexpired:perk];
                [array removeObjectAtIndex:i];
            }
        }
        else
        {
            perk.posy += perk.speedy;
            [game perkontheloose:perk];
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
        gxperk *perk = array[i];
        
        if(!perk.taken)
        {
            [perk render:_effect];
        }
    }
}

@end

@implementation gxperk
{
    NSMutableData *mutdataposition;
    NSMutableData *mutdatatexture;
    GLKVector2 *vecpos;
    GLKVector2 *vectex;
    GLKTextureInfo *texture;
    GLKVector4 color;
    GLuint texturename;
    GLKMatrix4 rotation;
    CGFloat midsize;
}

@synthesize type;
@synthesize posx;
@synthesize posy;
@synthesize size;
@synthesize midsize;
@synthesize speedy;
@synthesize ttl;
@synthesize taken;

-(gxperk*)init:(perktype)_type posx:(CGFloat)_posx posy:(CGFloat)_posy
{
    self = [super init];
    
    type = _type;
    posx = _posx;
    posy = _posy;
    taken = NO;
    color = GLKVector4Make(0.8, 0.9, 1, 1);
    size = 50;
//    speedy = 5;
    speedy = 2;
    
    switch(type)
    {
        case perktypelife:
            
            ttl = 0;
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"perk_life"].CGImage options:nil error:nil];
            
            break;
            
        case perktypebigball:
            
            ttl = 1000;
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"perk_bigball"].CGImage options:nil error:nil];
            
            break;
            
        case perktypebigbar:
            
            ttl = 1000;
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"perk_bigbar"].CGImage options:nil error:nil];
            
            break;
            
        case perktypeclock:
            
            ttl = 1000;
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"perk_clock"].CGImage options:nil error:nil];
            
            break;
            
        case perktypestarball:
            
            ttl = 1000;
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"perk_steelball"].CGImage options:nil error:nil];
            
            break;
            
        case perktypestarheart:
            
            ttl = 1000;
            texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:@"perk_steellife"].CGImage options:nil error:nil];
            
            break;
            
        case perktypenone:
            break;
    }
    
    midsize = size / 2;
    mutdataposition = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    mutdatatexture = [NSMutableData dataWithLength:6 * sizeof(GLKVector2)];
    vecpos = mutdataposition.mutableBytes;
    vectex = mutdatatexture.mutableBytes;
    texturename = texture.name;
    rotation = GLKMatrix4MakeRotation(0, 0, 0, 1);
    vectex[0] = GLKVector2Make(0, 0);
    vectex[1] = GLKVector2Make(0, 1);
    vectex[2] = GLKVector2Make(1, 1);
    vectex[3] = GLKVector2Make(1, 1);
    vectex[4] = GLKVector2Make(1, 0);
    vectex[5] = GLKVector2Make(0, 0);
    
    taken = NO;
    
    return self;
}

-(void)dealloc
{
    glDeleteTextures(1, &texturename);
}

#pragma mark public

-(void)repos
{
    midsize = size / 2;
    CGFloat minx = posx - midsize;
    CGFloat miny = posy - midsize;
    CGFloat maxx = posx + midsize;
    CGFloat maxy = posy + midsize;
    
    vecpos[0] = GLKVector2Make(minx, miny);
    vecpos[1] = GLKVector2Make(minx, maxy);
    vecpos[2] = GLKVector2Make(maxx, maxy);
    vecpos[3] = GLKVector2Make(maxx, maxy);
    vecpos[4] = GLKVector2Make(maxx, miny);
    vecpos[5] = GLKVector2Make(minx, miny);
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