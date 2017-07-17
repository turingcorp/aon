#import "ctrdrawer.h"

@implementation ctrdrawer
{
    GLKBaseEffect *effect;
}

@synthesize ball;
@synthesize bar;
@synthesize bricks;
@synthesize hearts;
@synthesize effects;
@synthesize perks;

-(ctrdrawer*)init:(ctrgame*)_game
{
    self = [super init];
    [self newgame:_game];
    
    effect = [[GLKBaseEffect alloc] init];
    effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, screenwidth, screenheight, 0, 1, -1);
    effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    effect.texture2d0.target = GLKTextureTarget2D;
    [effect prepareToDraw];
    
    return self;
}

#pragma mark public

-(void)newgame:(ctrgame*)_game
{
    ball = _game.ball;
    bar = _game.bar;
    bricks = _game.bricks;
    hearts = _game.hearts;
    effects = _game.effects;
    perks = _game.perks;
}

#pragma mark -
#pragma mark glkview del

-(void)glkView:(GLKView*)_view drawInRect:(CGRect)_rect
{
    glDisable(GL_DEPTH_TEST);
    glClearColor(1,1,1,1);
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
 
    [ball render:effect];
    [bar render:effect];
    [bricks render:effect];
    [hearts render:effect];
    [effects render:effect];
    [perks render:effect];
   
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    glDisable(GL_BLEND);
}

@end